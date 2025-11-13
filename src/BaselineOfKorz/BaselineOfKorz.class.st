Class {
	#name : #BaselineOfKorz,
	#superclass : #BaselineOf,
	#category : #BaselineOfKorz
}

{ #category : #baseline }
BaselineOfKorz >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Korz'
		]
]
