Class {
	#name : #KoSlotSpaceExamplesTest,
	#superclass : #TestCase,
	#category : #'Korz-Tests'
}

{ #category : #tests }
KoSlotSpaceExamplesTest >> testExampleSlotMatchingProvidesExpectedOverrides [
	| results |
	results := KoSlotSpaceExamples exampleSlotMatching.
	self assert: (results includesKey: #australia).
	self assert: (results includesKey: #colorblindAustralia).
	self assert: ((results at: #northern) asSet) equals: #('baseline renderer') asSet.
	self assert: ((results at: #australia) asSet)
		equals: #('baseline renderer' 'southern hemisphere override') asSet.
	self assert: ((results at: #colorblindAustralia) asSet)
		equals: #(
			'baseline renderer'
			'southern hemisphere override'
			'colorblind override'
			'southern colorblind override') asSet
]

{ #category : #tests }
KoSlotSpaceExamplesTest >> testBracketExampleHonorsAntiReflexRule [
	| results |
	results := KoSlotSpaceExamples exampleBracketSees.
	results keysAndValuesDo: [ :pov :perBoundary |
		perBoundary keysAndValuesDo: [ :boundary :seen |
			self assert: (seen includes: boundary) not
		]
	]
]

{ #category : #tests }
KoSlotSpaceExamplesTest >> testBracketExampleDiffersByPov [
	| results squareAdjacent squareSymmetric |
	results := KoSlotSpaceExamples exampleBracketSees.
	squareAdjacent := (results at: #adjacent) at: #square.
	squareSymmetric := (results at: #symmetric) at: #square.
	self deny: squareAdjacent asSet equals: squareSymmetric asSet
]

{ #category : #tests }
KoSlotSpaceExamplesTest >> testYonedaProfilesCollapseUnderMetaPov [
	| profiles local meta |
	profiles := KoSlotSpaceExamples exampleYonedaProfiles.
	local := profiles at: #local.
	meta := profiles at: #meta.
	self deny: ((local at: #nodeA) = (local at: #nodeC)).
	self assert: ((meta at: #nodeA) = (meta at: #nodeC))
]

{ #category : #tests }
KoSlotSpaceExamplesTest >> testPileSelectionSwitchesVisibleElements [
	| selectionResults |
	selectionResults := KoSlotSpaceExamples examplePileSelection.
	self assert: (selectionResults at: #tops) = #(topA topB).
	self assert: (selectionResults at: #all) = #(topA midC baseD)
]

{ #category : #tests }
KoSlotSpaceExamplesTest >> testCombinerPoliciesDescribeStrategies [
	| strategies |
	strategies := KoSlotSpaceExamples exampleCombinerPolicies.
	self assert: (strategies at: #meet) equals: 'intersection of candidates'.
	self assert: (strategies at: #quorum) equals: 'accept proposals supported by ≥ 2 POVs'
]
