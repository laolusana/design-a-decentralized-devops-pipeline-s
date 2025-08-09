Solidity
pragma solidity ^0.8.0;

contract DecentralizedDevOpsPipelineSimulator {
    // Mapping of pipeline IDs to pipeline configurations
    mapping (bytes32 => PipelineConfig) public pipelines;

    // Struct to represent a pipeline configuration
    struct PipelineConfig {
        address[] nodes; // list of node addresses
        bytes32[] stages; // list of stage IDs
        mapping (bytes32 => StageConfig) stagesConfig; // mapping of stage IDs to stage configurations
    }

    // Struct to represent a stage configuration
    struct StageConfig {
        bytes32[] tasks; // list of task IDs
        mapping (bytes32 => TaskConfig) tasksConfig; // mapping of task IDs to task configurations
    }

    // Struct to represent a task configuration
    struct TaskConfig {
        address executor; // address of the executor node
        bytes script; // script to be executed
    }

    // Event emitted when a pipeline is created
    event PipelineCreated(bytes32 pipelineId);

    // Event emitted when a pipeline is executed
    event PipelineExecuted(bytes32 pipelineId);

    // Event emitted when a stage is executed
    event StageExecuted(bytes32 pipelineId, bytes32 stageId);

    // Event emitted when a task is executed
    event TaskExecuted(bytes32 pipelineId, bytes32 stageId, bytes32 taskId);

    // Function to create a new pipeline
    function createPipeline(bytes32 pipelineId, address[] memory nodes, bytes32[] memory stages) public {
        PipelineConfig storage pipelineConfig = pipelines[pipelineId];
        pipelineConfig.nodes = nodes;
        pipelineConfig.stages = stages;
        emit PipelineCreated(pipelineId);
    }

    // Function to add a stage to a pipeline
    function addStageToPipeline(bytes32 pipelineId, bytes32 stageId, bytes32[] memory tasks) public {
        PipelineConfig storage pipelineConfig = pipelines[pipelineId];
        pipelineConfig.stagesConfig[stageId].tasks = tasks;
    }

    // Function to add a task to a stage
    function addTaskToStage(bytes32 pipelineId, bytes32 stageId, bytes32 taskId, address executor, bytes memory script) public {
        PipelineConfig storage pipelineConfig = pipelines[pipelineId];
        pipelineConfig.stagesConfig[stageId].tasksConfig[taskId].executor = executor;
        pipelineConfig.stagesConfig[stageId].tasksConfig[taskId].script = script;
    }

    // Function to execute a pipeline
    function executePipeline(bytes32 pipelineId) public {
        PipelineConfig storage pipelineConfig = pipelines[pipelineId];
        for (uint i = 0; i < pipelineConfig.stages.length; i++) {
            bytes32 stageId = pipelineConfig.stages[i];
            for (uint j = 0; j < pipelineConfig.stagesConfig[stageId].tasks.length; j++) {
                bytes32 taskId = pipelineConfig.stagesConfig[stageId].tasks[j];
                address executor = pipelineConfig.stagesConfig[stageId].tasksConfig[taskId].executor;
                bytes memory script = pipelineConfig.stagesConfig[stageId].tasksConfig[taskId].script;
                // Execute the task using the executor node
                // ...
                emit TaskExecuted(pipelineId, stageId, taskId);
            }
            emit StageExecuted(pipelineId, stageId);
        }
        emit PipelineExecuted(pipelineId);
    }
}