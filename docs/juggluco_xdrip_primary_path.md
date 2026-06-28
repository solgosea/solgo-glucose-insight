# Juggluco -> xDrip+ Primary Path

Status Monitor observes the same outbound path that users rely on when
Juggluco sends glucose data to xDrip+.

## Observed Paths

| Path | Android action | Meaning |
| --- | --- | --- |
| Patched Libre | `com.librelink.app.ThirdPartyIntegration.GLUCOSE_READING` | xDrip+ hardware source path for Libre patched app style broadcasts. |
| 640G/EverSense | `com.eveningoutpost.dexdrip.NS_EMULATOR` | xDrip+ Nightscout emulator path used by 640G / EverSense style sources. |
| xDrip local | `com.eveningoutpost.dexdrip.BgEstimate` | Inter-app broadcast shape. Useful evidence, but not the hardware-source handoff itself. |
| Glucodata direct | `glucodata.Minute` | Direct Juggluco broadcast to selected apps. Useful for SolgoInsight observation, but it does not prove xDrip+ primary path is receiving. |

## Status Semantics

- Patched Libre or 640G/EverSense observed: xDrip-compatible primary path is observed.
- Glucodata only: direct broadcast is visible, but xDrip-compatible path is still pending.
- No broadcast: receiver is ready but waiting for the first Juggluco broadcast.

Debug scripts must say they are receiver tests. They must not claim to send CGM
data into Juggluco.
