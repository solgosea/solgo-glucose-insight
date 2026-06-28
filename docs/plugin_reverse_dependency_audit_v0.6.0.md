# Solgo Insight v0.6.0 插件反向依赖审查

## 审查目的

本次审查关注一个核心问题：

**按照插件架构设计，主系统不应该直接知道每一个具体插件的存在。**

理想依赖方向应该是：

```text
core / domain / application / infrastructure
        |
        v
plugin_platform contracts
        ^
        |
concrete feature plugins
```

也就是说：

- 主系统可以知道 `plugin_platform` 的抽象接口。
- 插件可以依赖主系统提供的稳定服务、领域模型和插件契约。
- 具体插件之间不应该随意互相 import。
- 主系统不应该直接 import 某个具体插件。
- 只有发布装配层可以知道“本版本包含哪些插件”。

## 当前总体结论

当前代码已经基本避免了“主系统到处直接引用具体插件”的问题。具体插件主要集中在：

```text
lib/plugins/plugin_catalog.dart
```

这个文件目前承担 **release assembly / plugin catalog** 的角色，集中声明本次版本启用哪些插件。这种集中式清单在当前阶段是可以接受的。

但仍然发现几类架构风险：

1. `alerting` 作为顶层能力模块，直接依赖了 `settings` 插件的 slot。
2. `infrastructure/background` 直接依赖了 `plugins/background_capability_catalog.dart`。
3. 多个插件通过 `ProfileSlots`、`ExploreSlots`、`SettingsSlots` 产生横向耦合。
4. `plugin_catalog.dart` 作为手写清单，长期会变成所有插件的中心硬编码点。

这些问题目前不会阻塞 v0.6.0 发布，但建议作为后续插件架构优化项。

## 允许存在的依赖

### 1. `lib/plugins/plugin_catalog.dart`

当前文件：

```text
lib/plugins/plugin_catalog.dart
```

它 import 了所有本版本启用的插件，例如：

```dart
import 'home/home_plugin.dart';
import 'history/history_plugin.dart';
import 'statistics/statistics_plugin.dart';
import 'explore/status_monitor/status_monitor_plugin.dart';
```

判断：

**可以接受。**

原因：

- 这是发布装配清单，不是业务主系统。
- 它把“本版本启用哪些插件”的知识集中在一个地方。
- `main.dart` 并没有逐个 import 具体插件。

风险：

- 插件越来越多后，这个文件会变成手动维护的中心清单。
- 如果未来做 Community / Pro / Follow / Store 多版本发布，手写清单容易出错。

建议：

- 短期继续保留。
- 中期拆分为：

```text
lib/plugins/catalog/community_plugin_catalog.dart
lib/plugins/catalog/full_plugin_catalog.dart
lib/plugins/catalog/store_plugin_catalog.dart
```

- 长期可以考虑 build-time generated catalog 或 manifest-driven catalog。

## 不合理或需要优化的依赖

### 1. Alerting 依赖 Settings 插件 slot

文件：

```text
lib/alerting/alerting_plugin.dart
```

当前依赖：

```dart
import '../plugins/settings/composition/settings_slots.dart';
```

问题：

`alerting` 当前位于顶层目录：

```text
lib/alerting
```

它不是 `lib/plugins/settings` 的子模块，却直接依赖了 settings 插件内部的 `SettingsSlots`。这意味着 Alerting 插件想把自己放进 Settings 页面时，必须知道 Settings 插件的内部 slot 定义。

这属于典型的横向插件耦合：

```text
AlertingPlugin -> SettingsPlugin internals
```

风险：

- Settings 插件 slot 一改，Alerting 插件必须跟着改。
- Alerting 无法独立于 Settings 插件复用。
- 后续如果 Settings 页面重构为新的 Profile / System / Preferences 宿主，Alerting 会被牵连。

建议改法：

把通用 slot contract 从具体 Settings 插件中抽出来，例如：

```text
lib/plugin_platform/slots/settings_slots.dart
```

或者：

```text
lib/application/navigation/app_extension_slots.dart
```

依赖方向改为：

```text
AlertingPlugin -> plugin_platform slot contract
SettingsPlugin -> plugin_platform slot contract
```

这样 Alerting 不再知道 Settings 插件，只知道“系统提供了 settings section 这个扩展点”。

优先级：

**P1，中期应修复。**

### 2. Background infrastructure 依赖 plugins catalog

文件：

```text
lib/infrastructure/background/background_service_entrypoint.dart
```

当前依赖：

```dart
import '../../plugins/background_capability_catalog.dart';
```

问题：

`infrastructure/background` 是底层运行时入口，但它直接 import 了 `plugins` 下的 catalog：

```text
infrastructure/background -> plugins/background_capability_catalog.dart
```

这会让 background service entrypoint 知道插件系统的具体装配来源。

背景说明：

这个问题有一定现实原因：background service 是独立 Dart entrypoint，不能简单复用前台 `main()` 已经创建好的 DI 容器，所以它需要重新装配后台能力。

所以这不是严重错误，但属于架构债务。

风险：

- 后台服务和插件发布清单耦合。
- 不同版本如果使用不同插件清单，后台 entrypoint 也容易被牵连。
- 后续如果 Status Monitor、Sync、Alert、Follow 都注册后台能力，这里会越来越重要。

建议改法：

建立专门的后台装配根：

```text
lib/app/background/background_composition_root.dart
```

让 entrypoint 只依赖 app-level composition root：

```text
background_service_entrypoint.dart
  -> BackgroundCompositionRoot.createCapabilityCatalog()
```

然后由 composition root 内部决定使用 community / full / store catalog。

优先级：

**P1，中期应修复。**

### 3. Datasource / Glance 依赖 ProfileSlots

文件：

```text
lib/plugins/datasource/datasource_plugin.dart
lib/plugins/glance/glance_plugin.dart
lib/plugins/glance/install/glance_composition_registrar.dart
```

当前依赖：

```dart
import 'package:smart_xdrip/plugins/profile/composition/profile_slots.dart';
```

问题：

Datasource 和 Glance 都需要把内容挂到 Profile 页面，但它们直接依赖了 Profile 插件内部定义的 slot。

依赖关系：

```text
DatasourcePlugin -> ProfilePlugin slots
GlancePlugin -> ProfilePlugin slots
```

这不是主系统反向依赖，但属于插件之间横向耦合。

风险：

- Profile 插件变成隐形宿主插件。
- Profile slot 一改，Datasource / Glance 都要跟着改。
- 如果未来 Profile 被拆分为 Account / Device / Preferences，其他插件迁移成本较高。

建议改法：

将 Profile 页面可扩展区域抽成公共 slot contract：

```text
lib/plugin_platform/slots/profile_slots.dart
```

或者将其定义为 app shell 层的扩展点：

```text
lib/app/shell/profile_extension_slots.dart
```

优先级：

**P2，可以在下一轮插件架构整理时处理。**

### 4. Status Monitor 依赖 ExploreSlots

文件：

```text
lib/plugins/explore/status_monitor/status_monitor_plugin.dart
lib/plugins/explore/status_monitor/install/status_monitor_composition_registrar.dart
```

当前依赖：

```dart
import 'package:smart_xdrip/plugins/explore/composition/explore_slots.dart';
```

问题：

Status Monitor 作为 Explore 下的功能插件，需要挂载到 Explore 页面，这是合理的产品关系。但从架构上看，它仍然直接依赖了 Explore 插件内部 slot。

依赖关系：

```text
StatusMonitorPlugin -> ExplorePlugin slots
```

风险：

- Explore 成为多个分析插件的隐形宿主。
- 如果后续调整为 `Insight Board` / `Tools` / `Care` 等新入口，插件迁移需要改 import。

建议改法：

把 Explore 插槽升级为公共 slot contract：

```text
lib/plugin_platform/slots/explore_slots.dart
```

或改名为更稳定的业务扩展点：

```text
PluginSlots.explorerPrimary
PluginSlots.explorerTools
PluginSlots.explorerReports
```

优先级：

**P2。**

### 5. `main.dart` 依赖 `plugins/builtin_plugins.dart`

文件：

```text
lib/main.dart
```

当前依赖：

```dart
import 'plugins/builtin_plugins.dart';
```

判断：

**可以接受，但可以继续优化。**

原因：

`main.dart` 并没有直接 import 每一个具体插件，而是只知道一个 built-in plugin registry。

当前结构：

```text
main.dart
  -> plugins/builtin_plugins.dart
      -> plugins/plugin_catalog.dart
```

这已经比主程序逐个引用具体插件要好。

建议：

如果希望更严格，可以把 `builtin_plugins.dart` 移到 app 装配层：

```text
lib/app/composition/app_plugin_catalog.dart
```

这样 `main.dart` 只面对 app composition，而不是直接面对 plugins 目录。

优先级：

**P3，可后续优化。**

## 当前没有发现的问题

### 1. Domain 没有直接依赖具体插件

未发现：

```text
lib/domain -> lib/plugins/*
```

这是好的。

说明核心领域模型没有反向知道插件存在。

### 2. Application 大部分没有直接依赖具体插件

除了 background / composition 相关路径外，主 application 层没有大规模 import 具体插件。

这是好的。

### 3. Data 层没有直接依赖具体插件

未发现明显：

```text
lib/data -> lib/plugins/*
```

这是好的。

### 4. Presentation common 没有直接依赖具体插件

未发现明显：

```text
lib/presentation/common -> lib/plugins/*
```

这是好的。

## 建议的目标架构

更理想的结构是：

```text
lib/
  app/
    composition/
      community_plugin_catalog.dart
      background_composition_root.dart

  plugin_platform/
    contracts/
    slots/
      home_slots.dart
      profile_slots.dart
      settings_slots.dart
      explore_slots.dart

  plugins/
    home/
    profile/
    settings/
    explore/
    status_monitor/
    report/
    high_episode/
    low_episode/
```

依赖方向：

```text
main.dart
  -> app/composition
      -> plugin_catalog
          -> concrete plugins

concrete plugins
  -> plugin_platform/contracts
  -> plugin_platform/slots
  -> application/domain shared services
```

避免：

```text
domain/application/data/infrastructure
  -> concrete plugins
```

也尽量避免：

```text
plugin A -> plugin B internals
```

## 分阶段整改建议

### Phase 1：移动 slots，降低插件横向耦合

优先把这些 slot contract 移出具体插件目录：

```text
SettingsSlots
ProfileSlots
ExploreSlots
```

建议目标：

```text
lib/plugin_platform/slots/settings_slots.dart
lib/plugin_platform/slots/profile_slots.dart
lib/plugin_platform/slots/explore_slots.dart
```

收益：

- Alerting 不再依赖 Settings 插件。
- Datasource / Glance 不再依赖 Profile 插件。
- Status Monitor 不再依赖 Explore 插件内部实现。

### Phase 2：拆出 background composition root

新增：

```text
lib/app/background/background_composition_root.dart
```

让后台 entrypoint 不再直接 import `plugins/background_capability_catalog.dart`。

收益：

- 后台服务只依赖 app 装配层。
- 为不同版本的后台能力组合做准备。

### Phase 3：版本化 plugin catalog

拆分：

```text
community_plugin_catalog.dart
full_plugin_catalog.dart
store_plugin_catalog.dart
```

收益：

- Community Preview、正式版、Follow/Care 版可以各自声明插件范围。
- 降低发布时误带未公开插件的风险。

### Phase 4：插件 manifest 化

长期可以考虑每个插件提供 manifest：

```text
plugin.json / plugin_manifest.dart
```

再由脚本生成 catalog。

收益：

- 插件新增/删除更可控。
- 发布清单可审计。
- 更接近真正插件平台。

## 优先级总结

| 优先级 | 问题 | 文件 | 建议 |
|---|---|---|---|
| P1 | Alerting 依赖 Settings 插件 slot | `lib/alerting/alerting_plugin.dart` | 将 `SettingsSlots` 移到 `plugin_platform/slots` |
| P1 | Background entrypoint 依赖 plugin catalog | `lib/infrastructure/background/background_service_entrypoint.dart` | 新增 background composition root |
| P2 | Datasource / Glance 依赖 ProfileSlots | `lib/plugins/datasource/*`, `lib/plugins/glance/*` | 将 `ProfileSlots` 移到公共 slot contract |
| P2 | Status Monitor 依赖 ExploreSlots | `lib/plugins/explore/status_monitor/*` | 将 `ExploreSlots` 移到公共 slot contract |
| P3 | `main.dart` 依赖 `plugins/builtin_plugins.dart` | `lib/main.dart` | 可移动到 `app/composition` |
| P3 | 手写 `plugin_catalog.dart` 会随插件增长变重 | `lib/plugins/plugin_catalog.dart` | 后续做版本化或生成式 catalog |

## 结论

当前 v0.6.0 的插件架构已经比传统硬编码页面结构更清晰：主系统并没有大量直接知道具体插件。

但如果目标是长期做成真正的插件平台，下一步最值得做的是：

**把页面插槽从具体插件中抽离出来，变成 plugin_platform 层的公共扩展点。**

这样每个插件只知道“我要挂到某个稳定扩展点”，而不是知道“我要挂到某个具体插件内部”。

这会明显降低后续 Follow、Status Monitor、Report、Widget、Watch Display 等能力继续扩展时的耦合风险。
