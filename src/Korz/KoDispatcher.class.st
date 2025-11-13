Class {
	#name : #KoDispatcher,
	#superclass : #Object,
	#category : #'Korz-Projection-Model'
}

{ #category : #dispatching }
KoDispatcher class >> dispatchSelector: selector arguments: arguments inContext: aContext onSlotSpace: slotSpace [
	| koContext bestSlots |
	koContext := self ensureContext: aContext.
	bestSlots := slotSpace bestSlotsForContext: koContext selector: selector arguments: arguments.
	bestSlots ifEmpty: [ KoMessageNotUnderstood signalSelector: selector context: koContext ].
	bestSlots size > 1 ifTrue: [ KoAmbiguousDispatch signalSelector: selector slots: bestSlots context: koContext ].
	^ bestSlots first evaluateInContext: koContext withArguments: arguments
]

{ #category : #private }
KoDispatcher class >> ensureContext: aContext [
	(aContext isKindOf: KoContext) ifTrue: [ ^ aContext ].
	(aContext respondsTo: #at:ifAbsent:) ifTrue: [ ^ KoContext fromDictionary: aContext ].
	^ KoContext empty
]
