data "archive_file" "zip_project" {
  type = "zip"

  source_dir  = "${var.file_name}"
  output_path = "${var.file_name}.zip"
}   

resource "aws_s3_object" "project_object" {
  bucket = "${var.project_bucket}"

  key    = "project/${var.file_name}.zip"
  source = data.archive_file.zip_project.output_path

  etag = filemd5(data.archive_file.zip_project.output_path)

  depends_on = [
    data.archive_file.zip_project
  ]
}