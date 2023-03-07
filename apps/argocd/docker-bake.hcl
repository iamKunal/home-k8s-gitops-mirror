variable HOME { }

variable "GIT_SHA" {
  default = "latest"
}

variable "GIT_COMMIT_MESSAGE" {
  default = "No info available"
}


variable "REPO" {
  default = "registry.docker.home.stackpwn.in:80/gh-cli"
}

function "tag" {
  params = [tag]
  result = "${REPO}:${tag}"
}

group "default" {
  targets = ["gh-cli"]
}

target "gh-cli" {
  dockerfile = "gh-cli.Dockerfile"
  tags       = [
    tag("latest"),
    tag("${GIT_SHA}")
  ]
  secret = [
    "id=gh_token,src=${HOME}/.config/gh/hosts.yml"
  ]
  labels = {
    changes = "${GIT_COMMIT_MESSAGE}"
    git_sha = "${GIT_SHA}"
  }
}
