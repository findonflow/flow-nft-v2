# Examples on code to initialize propperly

```go run main.go```


current results

```
reating account emulator-user
Transaction ID: ce468d563ecb788504db59fcef11b262cd16d794479d3f4b1fd2d556461c1c89

Deploying 8 contracts for accounts: emulator-account,emulator-user

ViewResolver -> 0xf8d6e0586b0a20c7 [skipping, no changes found]
NonFungibleToken -> 0xf8d6e0586b0a20c7 (5a878f1c3c6bd5a3b5f6f6b18a26a4f8cbea7170c5112e0dc23f08459081fdf6) [updated]
FungibleToken -> 0xf8d6e0586b0a20c7 (dfc066f05cdb89afb5216121915793a0280d646c0ac81732e3cf41c5e7ba1f36) [updated]
MetadataViews -> 0xf8d6e0586b0a20c7 (d9f15e37797a0f1dbcef84666e71f383a4cef7ae413e95e99d3bd883a5c94e4a) [updated]
ExampleNFT -> 0xf8d6e0586b0a20c7 (b50c8ffb280ea85a8cef260c05865c7375a048a8028aea9ef92dcf911d5e763a) [updated]
NFTForwarding -> 0xf8d6e0586b0a20c7 (e10ff626c9ad13d39dad6d653d529521646203857d38fbcc85f37c4ca02cbfe5) [updated]
UniversalCollection -> 0xf8d6e0586b0a20c7 (f7281f4af299a82fbdc96020e7acc8078f93902245784bae2915fc8bacca569a) [updated]
BasicNFT -> 0xf8d6e0586b0a20c7 (68b412ff251268fa90c49fdc20d1ea93c96aa452d8a73e427b8375299ef5e077) [updated]

🎉 All contracts deployed successfully
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
check type when has universal collection

⭐ Script test7 run result:[
    "store something that is NFT collection",
    "we do not store exampleNFT collection",
    "we could load and destory and add new collection"
]
try to load and destory if string

⭐ Script test8 run result:[
    "we could load and destory and add new collection"
]
try to borrow using anyResource with string panics

script: test9: scriptFileName:test9: [Error Code: 1101] error caused by: 1 error occurred:
	* [Error Code: 1101] cadence runtime error: Execution failed:
error: failed to force-cast value: expected type `AnyResource`, got `String`
  --> cf2eac1014596b54285f8fc93718daf6466870045b31a5e2c94222b5494f4b69:23:13
   |
23 |     let col= signer.storage.borrow<&AnyResource>(from: collectionData.storagePath) as? &{NonFungibleToken.Collection}?
   |              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


try to borrow using anyResource with another resource

⭐ Script test10 run result:[
    "borrow using anyResource and then cast as restricted type"
]
try to borrow using anyResource with nothing stored

⭐ Script test11 run result:[
    "borrow using anyResource and then cast as restricted type, is empty"
]
provider path test with interface impl

⭐ Script test12 run result:[
    "could not find provider",
    "find provider second time",
    "Capability\u003cauth(A.f8d6e0586b0a20c7.NonFungibleToken.Withdraw)\u0026{A.f8d6e0586b0a20c7.NonFungibleToken.Collection}\u003e",
    "is provider cap"
]
provider path test with concrete impl

⭐ Script test13 run result:[
    "cap 3",
    "cap 4",
    "pre 3 /storage/cadenceExampleNFTCollection",
    "issued providerCap 5",
    "find provider second time",
    "Capability\u003cauth(A.f8d6e0586b0a20c7.NonFungibleToken.Withdraw)\u0026{A.f8d6e0586b0a20c7.NonFungibleToken.Collection}\u003e",
    "is provider cap",
    "post 3 /storage/cadenceExampleNFTCollection"
]
👌 Tx:test_init fee:0.00001000 gas:34 id:6d142cc0c2f7843dcd120d82a3c9df108cadf3b6b96129dbc1ba961ecba92097
=== LOG ===
Cadence log: "cap 3"
Cadence log: "pre 3 /storage/cadenceExampleNFTCollection"
Cadence log: "issued providerCap 4"
Cadence log: "find provider second time"
Cadence log: "Capability<auth(A.f8d6e0586b0a20c7.NonFungibleToken.Withdraw)&{A.f8d6e0586b0a20c7.NonFungibleToken.Collection}>"
Cadence log: "is provider cap"
Cadence log: "post 3 /storage/cadenceExampleNFTCollection"
Cadence log: "post 4 /storage/cadenceExampleNFTCollection"
transaction execution data
=== METER ===
LedgerInteractionUsed: 116251
Computation: 0
Computation Intensities:
 Statement:43
  FunctionInvocation:59
  CreateCompositeValue:2
  TransferCompositeValue:8
  CreateArrayValue:2
  TransferArrayValue:0
  CreateDictionaryValue:2
  TransferDictionaryValue:0
  EncodeValue:1164
  ComputationKind(2005):3
  ComputationKind(2008):1
  ComputationKind(2011):36
  ComputationKind(2015):36
  ComputationKind(2020):1352
  ComputationKind(2022):33
  ComputationKind(2026):1354
  ComputationKind(2034):39
  ComputationKind(2035):2
```

