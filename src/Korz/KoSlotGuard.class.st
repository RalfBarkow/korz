Class {
	#name : #KoSlotGuard,
	#superclass : #Object,
	#instVars : [
		'dimensionConstraints',
		'parameterConstraints',
		'selector'
	],
	#category : #Korz
}

{ #category : #'instance creation' }
KoSlotGuard class >> selector: aSelector [
	"Convenience factory with empty constraints."

	^ self
		selector: aSelector
		dimensionConstraints: Dictionary new
		parameterConstraints: nil
]

{ #category : #'instance creation' }
KoSlotGuard class >> selector: aSelector dimensionConstraints: aDict parameterConstraints: aParam [
	^ self new
		selector: aSelector;
		dimensionConstraints: (aDict ifNil: [ Dictionary new ]);
		parameterConstraints: aParam;
		yourself
]

{ #category : #accessing }
KoSlotGuard >> acceptableConstraints [
	"Default to dimensionConstraints if present; never nil."

	^ (self respondsTo: #dimensionConstraints)
		ifTrue: [ self dimensionConstraints ifNil: [ Dictionary new ] ]
		ifFalse: [ Dictionary new ]
]

{ #category : #accessing }
KoSlotGuard >> dimensionConstraints [
	^ self kozGuardState at: #dimensionConstraints ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
KoSlotGuard >> dimensionConstraints: aDict [
	dimensionConstraints := aDict
]

{ #category : #storage }
KoSlotGuard >> kozGuardState [
	^ KoSlotGuardState at: self ifAbsentPut: [ Dictionary new ]
]

{ #category : #accessing }
KoSlotGuard >> parameterConstraints [
	^ self kozGuardState at: #parameterConstraints ifAbsent: [ Dictionary new ]
]

{ #category : #accessing }
KoSlotGuard >> parameterConstraints: aParam [
	parameterConstraints := aParam
]

{ #category : #accessing }
KoSlotGuard >> selector [
	^ selector
]

{ #category : #accessing }
KoSlotGuard >> selector: aSelector [
	selector := aSelector
]
