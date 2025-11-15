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
KoSlotGuard class >> selector: aSelector dimensionConstraints: dimConstraints parameterConstraints: paramConstraints [
	^ self new
		selector: aSelector;
		dimensionConstraints: dimConstraints;
		parameterConstraints: paramConstraints;
		yourself
]

{ #category : #accessing }
KoSlotGuard >> acceptableConstraints [
	"Hook for future generalization.
	For now we just forward to dimensionConstraints."
	^ self dimensionConstraints
]

{ #category : #accessing }
KoSlotGuard >> dimensionConstraints [
	^ dimensionConstraints
]

{ #category : #initialization }
KoSlotGuard >> dimensionConstraints: aDictionary [
	dimensionConstraints := aDictionary
]

{ #category : #storage }
KoSlotGuard >> kozGuardState [
	^ KoSlotGuardState at: self ifAbsentPut: [ Dictionary new ]
]

{ #category : #accessing }
KoSlotGuard >> parameterConstraints [
	^ parameterConstraints
]

{ #category : #initialization }
KoSlotGuard >> parameterConstraints: aDictionaryOrNil [
	parameterConstraints := aDictionaryOrNil
]

{ #category : #accessing }
KoSlotGuard >> selector [
	^ selector
]

{ #category : #initialization }
KoSlotGuard >> selector: aSelector [
	selector := aSelector
]
