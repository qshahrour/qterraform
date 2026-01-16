resource "aws_ecr_repository" "backend" {
  name                 = "back"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "backend_policy" {
  repository = aws_ecr_repository.backend.name
  
  policy = jsonencode({
	rules = [
	  {
		rulePriority = 1
		description  = "Keep last 5 images"
		selection = {
			tagStatus   = "any"
          		countType   = "imageCountMoreThan"
          		countNumber = 5
        	}
      	 	action = {
         		 type = "expire"
        	}
      	}
    ]
  })
}

resource "aws_ecr_repository" "frontend" {
  name                 = "front"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "frontend_policy" {
  repository = aws_ecr_repository.frontend.name

  policy = jsonencode({
        rules = [
          {
                rulePriority = 1
                description  = "Keep last 5 images"
                selection = {
                        tagStatus   = "any"
                        countType   = "imageCountMoreThan"
                        countNumber = 5
                }
                action = {
                         type = "expire"
                }
        }
    ]
  })
}

