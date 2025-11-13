Class {
	#name : #KoAmbiguousDispatch,
	#superclass : #Error,
	#instVars : [
		'selector',
		'slots',
		'context'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoAmbiguousDispatch class >> signalSelector: aSelector slots: slotCollection context: aContext [
	self new
		selector: aSelector;
		slots: slotCollection;
		context: aContext;
		signal
]

{ #category : #accessing }
KoAmbiguousDispatch >> context [
	^ context
]

{ #category : #accessing }
KoAmbiguousDispatch >> context: aContext [
	context := aContext
]

{ #category : #accessing }
KoAmbiguousDispatch >> messageText [
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'Ambiguous slots for selector ';
			nextPutAll: selector asString;
			nextPutAll: ' in context ';
			print: context;
			nextPutAll: ' -> ';
			print: slots ]
]

{ #category : #accessing }
KoAmbiguousDispatch >> selector [
	^ selector
]

{ #category : #accessing }
KoAmbiguousDispatch >> selector: aSelector [
	selector := aSelector
]

{ #category : #accessing }
KoAmbiguousDispatch >> slots [
	^ slots
]

{ #category : #accessing }
KoAmbiguousDispatch >> slots: slotCollection [
	slots := slotCollection
]
