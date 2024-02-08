import "NonFungibleToken"
import "ExampleNFT"
import "MetadataViews"
import "UniversalCollection"

transaction {

    let  providerCap : Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>

    prepare(signer: auth(Storage, Capabilities, BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue, UnpublishCapability) &Account) {

        let collectionData = ExampleNFT.resolveContractView(resourceType: nil, viewType: Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData? ?? panic("ViewResolver does not resolve NFTCollectionData view")

        let storagePathIdentifer = collectionData.storagePath.toString().split(separator:"/")[1]
        let providerIdentifier = storagePathIdentifer.concat("Provider")
        let providerStoragePath = StoragePath(identifier: providerIdentifier)!

        //if this stores anything but this it will panic, why does it not return nil?
        let existingProvider= signer.storage.copy<Capability<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>>(from: providerStoragePath) 
        if existingProvider==nil {
            self.providerCap=signer.capabilities.storage.issue<auth(NonFungibleToken.Withdraw) &{NonFungibleToken.Collection}>(collectionData.storagePath)
            //we save it to storage to memoize it
            signer.storage.save(self.providerCap, to: providerStoragePath)
            log("create new cap")
        }else {
            self.providerCap= existingProvider!
            log("existing")
        }
    }
}

