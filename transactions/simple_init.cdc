import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"

transaction {

    let  providerCap : Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>

    prepare(signer: auth(Storage, Capabilities, BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account) {

        let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")

        let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
        let providerIdentifier = storagePathIdentifer.concat("Provider")
        let providerStoragePath = StoragePath(identifier: providerIdentifier)!

        let existingProvider= signer.storage.borrow<&Capability>(from: providerStoragePath) 

        if existingProvider==nil {
            self.providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
            //we save it to storage to memoize it
            signer.storage.save(self.providerCap, to: providerStoragePath)
        } else if existingProvider!.check<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(){
            //looks like i cannot cast this. 
            //error: failed to force-cast value: expected type `Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>`, got `&Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>`
            self.providerCap= existingProvider! as! Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>
        } else {
            //added this line so that it compilesz
            self.providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
            log("We have something stored that is not our cap")
        }
    }
}

