Class {
	#name : #BaselineOfKorz,
	#superclass : #BaselineOf,
	#category : #BaselineOfKorz
}

{ #category : #baseline }
BaselineOfKorz >> baseline: spec [
	<baseline>
	^ spec for: #common do: [
		spec package: 'Korz'.
		spec package: 'Korz-Examples' with: [ spec requires: #('Korz') ].
		spec package: 'Korz-Tests' with: [ spec requires: #('Korz' 'Korz-Examples') ]
	]
]
