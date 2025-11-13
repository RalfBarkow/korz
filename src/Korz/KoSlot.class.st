Class {
	#name : #KoSlot,
	#superclass : #Object,
	#instVars : [
		'guard',
		'contents'
	],
	#category : #'Korz-Projection-Model'
}

{ #category : #'instance creation' }
KoSlot class >> guard: aGuard contents: slotContents [
	^ self new
		guard: aGuard;
		contents: slotContents;
		yourself
]

{ #category : #evaluating }
KoSlot >> evaluateInContext: aContext withArguments: arguments [
	contents isBlock ifTrue: [
		contents numArgs caseOf: {
			[ 0 ] -> [ ^ contents value ].
			[ 1 ] -> [ ^ contents value: aContext ].
			[ 2 ] -> [ ^ contents value: aContext value: arguments ] }
			otherwise: [ ^ contents valueWithArguments: { aContext. arguments } ].
	].
	^ contents
]

{ #category : #accessing }
KoSlot >> guard [
	^ guard
]

{ #category : #accessing }
KoSlot >> guard: aGuard [
	guard := aGuard
]

{ #category : #accessing }
KoSlot >> contents [
	^ contents
]

{ #category : #accessing }
KoSlot >> contents: slotContents [
	contents := slotContents
]

{ #category : #testing }
KoSlot >> matchesContext: aContext arguments: arguments [
	^ guard matchesContext: aContext arguments: arguments
]

{ #category : #printing }
KoSlot >> printOn: aStream [
	aStream
		nextPutAll: 'KoSlot(';
		nextPutAll: guard selector asString;
		nextPutAll: ')'
]
