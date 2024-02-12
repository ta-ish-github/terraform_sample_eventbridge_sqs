resource "aws_cloudwatch_event_bus" "workflow_to_other_event_bus" {
  name = "workflow_to_other_event_bus"

}


#### ルール１（to A system Queue)
resource "aws_cloudwatch_event_rule" "workflow_to_a_event_rule" {
  name        = "workflow_to_a_event_rule"
  description = "workflow_to_a_event_rule"
  event_bus_name = aws_cloudwatch_event_bus.workflow_to_other_event_bus.name

  event_pattern = jsonencode({
    "detail": {
        "type": ["a-rule"]
    } 
  })
}

resource "aws_cloudwatch_event_target" "workflow_to_a_event_target" {
  rule      = aws_cloudwatch_event_rule.workflow_to_a_event_rule.name
  target_id = "workflow_to_a_event_target"
  arn       = aws_sqs_queue.a_system_que.arn
  event_bus_name = aws_cloudwatch_event_bus.workflow_to_other_event_bus.name
  sqs_target {
    message_group_id = "group_id_1"
  }
}


resource "aws_sqs_queue" "a_system_que" {
  name                        = "a_system_que.fifo"
  fifo_queue                  = true
  content_based_deduplication = true

#   // 保持期間を秒で指定 (この例では3日間)
#   message_retention_seconds = 60 * 60 * 24 * 3

#   receive_wait_time_seconds = 5

#   visibility_timeout_seconds = 20

  tags = {
    Environment = "local"
  }
}


#### ルール２（to B system Queue) ############################################
resource "aws_cloudwatch_event_rule" "workflow_to_b_event_rule" {
  name        = "workflow_to_b_event_rule"
  description = "workflow_to_b_event_rule"
  event_bus_name = aws_cloudwatch_event_bus.workflow_to_other_event_bus.name

  event_pattern = jsonencode({
    "detail": {
        "type": ["b-rule"]
    } 
  })
}

resource "aws_cloudwatch_event_target" "workflow_to_b_event_target" {
  rule      = aws_cloudwatch_event_rule.workflow_to_b_event_rule.name
  target_id = "workflow_to_b_event_target"
  arn       = aws_sqs_queue.b_system_que.arn
  event_bus_name = aws_cloudwatch_event_bus.workflow_to_other_event_bus.name
  sqs_target {
    message_group_id = "group_id_222"
  }
}


resource "aws_sqs_queue" "b_system_que" {
  name                        = "b_system_que.fifo"
  fifo_queue                  = true
  content_based_deduplication = true

  tags = {
    Environment = "local B"
  }
}



#### ルール３（to C system Queue) ############################################
resource "aws_cloudwatch_event_rule" "workflow_to_c_event_rule" {
  name        = "workflow_to_c_event_rule"
  description = "workflow_to_c_event_rule"
  event_bus_name = aws_cloudwatch_event_bus.workflow_to_other_event_bus.name

  event_pattern = jsonencode({
    "detail": {
        "type": ["b-rule"]
    } 
  })
}

resource "aws_cloudwatch_event_target" "workflow_to_c_event_target" {
  rule      = aws_cloudwatch_event_rule.workflow_to_c_event_rule.name
  target_id = "workflow_to_c_event_target"
  arn       = aws_sqs_queue.c_system_que.arn
  event_bus_name = aws_cloudwatch_event_bus.workflow_to_other_event_bus.name
  sqs_target {
    message_group_id = "group_id_333"
  }
}


resource "aws_sqs_queue" "c_system_que" {
  name                        = "c_system_que.fifo"
  fifo_queue                  = true
  content_based_deduplication = true

  tags = {
    Environment = "localC"
  }
}