variable HOME { }

variable REGISTRY {
  default = "registry.docker.home.stackpwn.in:80"
}

variable "GIT_SHA" {
  default = "latest"
}

variable "GIT_COMMIT_MESSAGE" {
  default = "No info available"
}


variable "REPO" {
  default = "${REGISTRY}/kubectl-gomplate"
}

function "tag" {
  params = [tag]
  result = "${REPO}:${tag}"
}

group "default" {
  targets = ["kubectl-gomplate"]
}

target "kubectl-gomplate" {
  dockerfile = "kubectl-gomplate.Dockerfile"
  tags       = [
    tag("latest"),
    tag("${GIT_SHA}")
  ]
  labels = {
    changes = "${GIT_COMMIT_MESSAGE}"
    git_sha = "${GIT_SHA}"
  }
}
