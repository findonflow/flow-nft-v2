# Examples on code to initialize propperly

```go run main.go```


current results

```
🧑 Created account: emulator-user with address: 01cf0e2f2f715450 with flow: 10.00
📜 deploy contracts ViewResolver, NonFungibleToken, FungibleToken, MetadataViews, ExampleNFT, NFTForwarding, UniversalCollection, BasicNFT
Try to borrow as a concrete NFT collection type when collection holds string

script: test1: scriptFileName:test1: [Error Code: 1101] error caused by: 1 error occurred:
	* [Error Code: 1101] cadence runtime error: Execution failed:
error: failed to force-cast value: expected type `ExampleNFT.Collection`, got `String`
  --> 64dbbf9217d4101b07406c5dc88b5062d7b374623829c967c454bb36112d14ee:20:7
   |
20 |     if signer.storage.borrow<&ExampleNFT.Collection>(from: collectionData.storagePath) != nil {
   |        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Try to borrow as a concrete NFT collection type when collection holds another resource

script: test2: scriptFileName:test2: [Error Code: 1101] error caused by: 1 error occurred:
	* [Error Code: 1101] cadence runtime error: Execution failed:
error: failed to force-cast value: expected type `ExampleNFT.Collection`, got `UniversalCollection.Collection`
  --> 3f5d7f237b5488a3b2ba975c58ea94faf96dc1e935b67b3d1338e1d51bee8ea8:22:7
   |
22 |     if signer.storage.borrow<&ExampleNFT.Collection>(from: collectionData.storagePath) != nil {
   |        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


Try to check instead of borrow while holding a different type

⭐ Script test3 run result:"OK; storage did not contain exampleNFT collection"
Try to check using interface

⭐ Script test4 run result:[
    "A.f8d6e0586b0a20c7.UniversalCollection.Collection",
    "cannot check that this implements interface {NonFungibleToken.Collection}"
]
Try to get type at path and then check if subtype

⭐ Script test5 run result:[
    "is nft collection"
]
check type when empty

⭐ Script test6 run result:[
    "does not store anything"
]

```

