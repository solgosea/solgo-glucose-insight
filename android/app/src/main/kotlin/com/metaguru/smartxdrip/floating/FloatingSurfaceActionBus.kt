package com.metaguru.smartxdrip.floating

object FloatingSurfaceActionBus {
    private var dispatcher: ((Map<String, Any?>) -> Unit)? = null

    fun configure(dispatcher: (Map<String, Any?>) -> Unit) {
        this.dispatcher = dispatcher
    }

    fun dispatch(segmentId: String, action: String, value: String?) {
        dispatcher?.invoke(
            mapOf(
                "segmentId" to segmentId,
                "action" to action,
                "value" to value
            )
        )
    }
}
