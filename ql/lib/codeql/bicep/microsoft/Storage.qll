private import codeql.Locations
private import codeql.bicep.ast.Expr
private import codeql.bicep.ast.Object
private import codeql.bicep.ast.Resources
private import codeql.bicep.ast.Literal

module Storage {
  class StorageAccounts extends Resource {
    StorageAccounts() {
      this.getResourceType().regexpMatch("^Microsoft.Storage/storageAccounts@.*")
    }

    Expr getKind() { result = this.getProperty("kind") }
  }

  class StorageAccountsProperties extends Object {
    private StorageAccounts storageAccounts;

    StorageAccountsProperties() { this = storageAccounts.getProperty("properties") }

    boolean getSupportsHttpsTrafficOnly() {
      result = this.getProperty("supportsHttpsTrafficOnly").(BooleanLiteral).getBool()
    }
  }

  class BlobServiceContainers extends Resource {
    BlobServiceContainers() {
      this.getResourceType()
          .regexpMatch("^Microsoft.Storage/storageAccounts/blobServices/containers@.*")
    }

    Object getProperties() { result = this.getProperty("properties") }

    string getPublicAccess() {
      result = this.getProperties().getProperty("publicAccess").(StringLiteral).getValue()
    }
  }
}
