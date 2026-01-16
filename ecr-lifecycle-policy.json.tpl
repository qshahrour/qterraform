{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep latest tag",
      "selection": {
        "tagStatus": "any",
        "tagPrefixList": ["latest"],
        "countType": "imageCountMoreThan",
        "countNumber": 1000
      },
      "action": {
        "type": "retain"
      }
    },
    {
      "rulePriority": 2,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}

