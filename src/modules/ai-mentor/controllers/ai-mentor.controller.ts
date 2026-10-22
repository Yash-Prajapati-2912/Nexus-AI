import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
  BadRequestException,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { AIMentorService } from '../services/ai-mentor.service';
import { ChatRequestDto } from '../dto/chat-request.dto';
import { ChatResponseDto } from '../dto/chat-response.dto';
import { ConversationQueryDto } from '../dto/conversation-query.dto';
import { ConversationResponseDto, MessageItemDto } from '../dto/conversation-response.dto';
import { UpdateConversationDto } from '../dto/update-conversation.dto';
import { MentorFeatureRequestDto } from '../dto/mentor-feature-request.dto';
import { MessageFeedbackDto } from '../dto/message-feedback.dto';

@ApiTags('Context-Aware AI Mentor')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('mentor')
export class AIMentorController {
  constructor(private readonly mentorService: AIMentorService) {}

  @Post('chat')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Send message to Context-Aware AI Personal Mentor' })
  @ApiResponse({ status: 200, description: 'AI mentor response generated', type: ChatResponseDto })
  async chat(
    @CurrentUser('id') userId: string,
    @Body() dto: ChatRequestDto,
  ): Promise<ChatResponseDto> {
    return this.mentorService.chat(userId, dto);
  }

  @Post('career')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get specialized Career mentoring and skill optimization guidance' })
  @ApiResponse({ status: 200, description: 'Career guidance response generated', type: ChatResponseDto })
  async careerMentor(
    @CurrentUser('id') userId: string,
    @Body() dto: MentorFeatureRequestDto,
  ): Promise<ChatResponseDto> {
    return this.mentorService.careerMentor(userId, dto);
  }

  @Post('study')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get specialized Academic & Study coaching' })
  @ApiResponse({ status: 200, description: 'Study coaching response generated', type: ChatResponseDto })
  async studyMentor(
    @CurrentUser('id') userId: string,
    @Body() dto: MentorFeatureRequestDto,
  ): Promise<ChatResponseDto> {
    return this.mentorService.studyMentor(userId, dto);
  }

  @Post('decision')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get Decision-Making mentoring and option evaluation framework' })
  @ApiResponse({ status: 200, description: 'Decision guidance response generated', type: ChatResponseDto })
  async decisionMentor(
    @CurrentUser('id') userId: string,
    @Body() dto: MentorFeatureRequestDto,
  ): Promise<ChatResponseDto> {
    return this.mentorService.decisionMentor(userId, dto);
  }

  @Post('productivity')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get Time Management & Productivity mentoring' })
  @ApiResponse({ status: 200, description: 'Productivity response generated', type: ChatResponseDto })
  async productivityMentor(
    @CurrentUser('id') userId: string,
    @Body() dto: MentorFeatureRequestDto,
  ): Promise<ChatResponseDto> {
    return this.mentorService.productivityMentor(userId, dto);
  }

  @Post('finance')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get Financial Wellness & Budget Mentoring' })
  @ApiResponse({ status: 200, description: 'Finance mentoring response generated', type: ChatResponseDto })
  async financeMentor(
    @CurrentUser('id') userId: string,
    @Body() dto: MentorFeatureRequestDto,
  ): Promise<ChatResponseDto> {
    return this.mentorService.financeMentor(userId, dto);
  }

  @Get('conversations')
  @ApiOperation({ summary: 'Get paginated list of user AI mentor conversations' })
  @ApiResponse({ status: 200, description: 'Conversations list returned', type: [ConversationResponseDto] })
  async getUserConversations(
    @CurrentUser('id') userId: string,
    @Query() queryDto: ConversationQueryDto,
  ): Promise<ConversationResponseDto[]> {
    return this.mentorService.getUserConversations(userId, queryDto);
  }

  @Get('conversations/:id')
  @ApiOperation({ summary: 'Get full conversation message history by ID' })
  @ApiParam({ name: 'id', description: 'Conversation UUID' })
  @ApiResponse({ status: 200, description: 'Conversation details returned', type: ConversationResponseDto })
  async getConversationById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<ConversationResponseDto> {
    return this.mentorService.getConversationById(userId, id);
  }

  @Get('conversations/:id/messages')
  @ApiOperation({ summary: 'Get full message history list by conversation ID' })
  @ApiParam({ name: 'id', description: 'Conversation UUID' })
  @ApiResponse({ status: 200, description: 'Conversation messages returned', type: [MessageItemDto] })
  async getConversationMessages(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<MessageItemDto[]> {
    return this.mentorService.getConversationMessages(userId, id);
  }

  @Patch('conversations/:id')
  @ApiOperation({ summary: 'Update conversation title, pin state, or archive status' })
  @ApiParam({ name: 'id', description: 'Conversation UUID' })
  @ApiResponse({ status: 200, description: 'Conversation updated successfully', type: ConversationResponseDto })
  async updateConversation(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateConversationDto,
  ): Promise<ConversationResponseDto> {
    return this.mentorService.updateConversation(userId, id, dto);
  }

  @Delete('conversations/:id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete (soft-delete) an AI mentor conversation' })
  @ApiParam({ name: 'id', description: 'Conversation UUID' })
  @ApiResponse({ status: 200, description: 'Conversation deleted successfully' })
  async deleteConversation(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.mentorService.deleteConversation(userId, id);
  }

  @Post('messages/:id/feedback')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Submit feedback rating and comments for an assistant message' })
  @ApiParam({ name: 'id', description: 'Target Message UUID' })
  @ApiResponse({ status: 200, description: 'Message feedback recorded successfully' })
  async submitMessageFeedback(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) messageId: string,
    @Body() dto: MessageFeedbackDto,
  ): Promise<{ success: boolean; feedbackId: string; updated: boolean }> {
    return this.mentorService.submitMessageFeedback(userId, messageId, dto);
  }

  @Post('chat/feedback')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Submit feedback rating and comments for a chat message' })
  @ApiResponse({ status: 200, description: 'Message feedback recorded successfully' })
  async submitChatFeedback(
    @CurrentUser('id') userId: string,
    @Body() dto: MessageFeedbackDto,
  ): Promise<{ success: boolean; feedbackId: string; updated: boolean }> {
    const targetId = dto.messageId;
    if (!targetId) {
      throw new BadRequestException('messageId is required');
    }
    return this.mentorService.submitMessageFeedback(userId, targetId, dto);
  }
}
