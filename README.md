# tf-scaffold

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)

This repository exists to help with new terraform projects, and with automation and training.
The repository is designed to create the structure- scaffold that is alway needed for a new Terraform project.
Included are the basic Github Actions.
To clone scaffold repository but with no .git folder.

## Powershell

```powershell
git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git scaffold
rm scaffold\.git -recurse -force
```

Edit your profile and add:

```powershell
function scaffold {
   param(
         [parameter(mandatory=$true)]
         [string]$name,
         [string]$branch="master")
   git clone --depth=1 --branch=$branch git@github.com:JamesWoolfenden/tf-scaffold.git "$name"
   rm "$name\.git" -recurse -force
}
```

or

```powershell
function scaffold {
   param(
         [parameter(mandatory=$true)]
         [string]$name,
         [string]$branch="master",
         [switch]$repo=$false)

   if (!(test-path .\$name))
   {
       git clone --depth=1 --branch=$branch git@github.com:JamesWoolfenden/tf-scaffold.git "$name"
   }
   else{
      write-warning "Path $name already exists"
      return
   }

   rm "$name\.git" -recurse -force
   cd $name
   echo "# %name" >README.md
   if ($repo)
   {
      git init|git add -A
      pre-commit install
      git commit -m "Initial Draft"
   }
}
```

Then you can use:

```powershell
scaffold -name hello-world
```

or to start a new git repo as well:

```powershell
scaffold -name hello-world -repo
```

To make a new project anytime you like.

## \*Nix

```cli
git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git scaffold| rm !$/.git -rf
```

Or you add this to your ~/.bashrc

```bash
function scaffold() {
if [ -z "$1" ]
then
   name="scaffold"
else
   name=$1
fi

if [ -z "$2" ]
then
   branch="master"
else
   branch=$2
fi


echo "git clone --depth=1 --branch $branch git@github.com:JamesWoolfenden/tf-scaffold.git $name"
git clone --depth=1 --branch $branch git@github.com:JamesWoolfenden/tf-scaffold.git $name
rm $name/.git -rf
}
```

## Usage

Once it's in your profile, pretty straigh forward:

```cli
 $ scaffold terraform-aws-generic
git clone --depth=1 git@github.com:JamesWoolfenden/tf-scaffold.git terraform-aws-generic
Cloning into 'terraform-aws-generic'...
remote: Enumerating objects: 14, done.
remote: Counting objects: 100% (14/14), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 14 (delta 0), reused 10 (delta 0), pack-reused 0
Receiving objects: 100% (14/14), done.
```

## So what's in it

### .gitignore

Has good defaults for working with Terraform

### .pre-commit-config.yaml

Has a standard set of pre-commit hooks for working with Terraform and AWS. You'll need to install the pre-commit framework <https://pre-commit.com/#install>.
And after you've added all these file to your new repo, in the root of your new repository:

```cli
pre-commit install
```

### main.tf

This is an expected file for Terraform modules. I don't use it.

### Makefile

This is just to make like easier for you. Problematic if you are cross platform as make isn't very good/awful at that.

### outputs.tf

A standard place to return values, either to the screen or to pass back from a module.

### provider.aws.tf

You are always going to be using these, I have added the most basic provider for AWS.

### README.md

Where all the information goes.

### main.auto.tfvars

This is the standard file for setting your variables in. The auto keyword ensures its picked up and used by Terraform.

### variables.tf

Contains a map variable **common_tags** which should be extended and used on
every taggable object.

### .dependsabot/config.yml

Sets the repository to be automatically dependency scanned in github.

## terraform-docs

If you leave the section below in your **README.md** then the pre-commit will auto update your docs.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_amplify_app.pike](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | n/a | <pre>object({<br>    name                  = string<br>    repository            = string<br>    build_spec            = string<br>    environment_variables = map(string)<br>  })</pre> | <pre>{<br>  "build_spec": "version: 0.1
frontend:
  phases:
    preBuild:
      commands:
        - yarn install
    build:
      commands:
        - yarn run build
  artifacts:
    baseDirectory: build
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
",<br>  "environment_variables": {<br>    "ENV": "test"<br>  },<br>  "name": "pike",<br>  "repository": "https://github.com/hortonworks/simple-yarn-app"<br>}</pre> | no |
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | n/a | <pre>list(object({<br>    source = string<br>    status = string<br>    target = string<br>  }))</pre> | <pre>[<br>  {<br>    "source": "/<*>",<br>    "status": "404",<br>    "target": "/index.html"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
