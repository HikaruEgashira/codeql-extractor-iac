private import codeql.iac.YAML
private import codeql.files.FileSystem

module AzurePipelines {
  /**
   * Azure DevOps Pipeline file.
   */
  class Document extends YamlNode, YamlDocument, YamlMapping {
    Document() {
      // Check the filename
      this.getFile().getBaseName() = ["azure-pipelines.yml", "azure-pipelines.yaml"]
    }

    override string toString() { result = "Azure DevOps Pipeline" }

    /**
     * Get the pipeline pool.
     */
    Pool getPool() { result = this.lookup("pool") }

    /**
     * Get the pipeline steps.
     */
    Step getSteps() { result = this.lookup("steps").getAChild() }

    /**
     * Get the pipeline task steps.
     */
    Task getTaskSteps() { result = this.getSteps().(Task) }

    /**
     * Get the pipeline script steps.
     */
    Script getScriptSteps() { result = this.getSteps().(Script) }
  }

  /**
   * Azure DevOps Pipeline pool.
   *
   * https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pool
   */
  class Pool extends YamlNode, YamlMapping {
    private Document pipeline;

    Pool() { pipeline.lookup("pool") = this }

    /**
     * Get the pool name.
     */
    string getName() { result = yamlToString(this.lookup("name")) }

    /**
     * Get the pool VM image.
     */
    string getVmImage() { result = yamlToString(this.lookup("vmImage")) }

    /**
     * Get the pool demands.
     */
    string getDemands() { result = yamlToString(this.lookup("demands")) }
  }

  class Step extends YamlNode, YamlMapping {
    private Document pipeline;

    Step() { pipeline.lookup("steps").getAChildNode() = this }

    override string toString() { result = "Azure DevOps Pipeline step" }

    /**
     * Get the step display name.
     */
    string displayName() { result = yamlToString(this.lookup("displayName")) }

    /**
     * Get the step type based on the presence of a `task` or `script` key.
     */
    string getType() {
      exists(this.lookup("task")) and result = "task"
      or
      exists(this.lookup("script")) and result = "script"
    }
  }

  class Task extends Step {
    Task() { this.getType() = "task" }

    /**
     * Get the task name.
     */
    string getName() { result = yamlToString(this.lookup("task")) }
  }

  class TaskInputs extends YamlNode, YamlMapping {
    private Task task;

    TaskInputs() { task.lookup("inputs") = this }

    YamlValue getInput(string name) { result = this.lookup(name) }
  }

  class Script extends Step {
    Script() { this.getType() = "script" }
  }
}
