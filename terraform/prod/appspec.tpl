applicationName: 'pokedex-prod-app'
deploymentGroupName: 'pokedex-prod-dg'
revision:
  revisionType: AppSpecContent
  appSpecContent:
    content: |
      version: 0.0
      Resources:
        - TargetService:
            Type: AWS::ECS::Service
            Properties:
              TaskDefinition: ${taskdefinition_arn}
              LoadBalancerInfo:
                ContainerName: pokedex-prod-container
                ContainerPort: 3000
