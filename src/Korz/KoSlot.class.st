Class {
	#name : #KoSlot,
	#superclass : #Object,
	#instVars : [
		'name',
		'guard',
		'implementation'
	],
	#category : #'Korz-Projection-Compat'
}

{ #category : #'private - building' }
KoSlot class >> guard: anObject contents: anObject1 [
	
]

{ #category : #'instance creation' }
KoSlot class >> selector: aSelector dimensionConstraints: aDict parameterConstraints: aParam implementation: aBlock [
	^ self new
		name: aSelector;
		guard: (KoSlotGuard
				selector: aSelector
				dimensionConstraints: (aDict ifNil: [ Dictionary new ])
				parameterConstraints: aParam);
		implementation: aBlock;
		yourself
]

{ #category : #'instance creation' }
KoSlot class >> selector: aSelector implementation: aBlock [
	^ self
		selector: aSelector
		dimensionConstraints: Dictionary new
		parameterConstraints: nil
		implementation: aBlock
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
KoSlot >> implementation [
	^ implementation
]

{ #category : #accessing }
KoSlot >> implementation: aBlock [
	implementation := aBlock
]

{ #category : #accessing }
KoSlot >> name [
	^ name
]

{ #category : #accessing }
KoSlot >> name: aSymbol [
	name := aSymbol
]

{ #category : #evaluating }
KoSlot >> valueWithReceiver: aReceiver arguments: argArray [
	"Simple convention: implementation is a block taking receiver and arguments."

	^ implementation value: aReceiver value: argArray
]
