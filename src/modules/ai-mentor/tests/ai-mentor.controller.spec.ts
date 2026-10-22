import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException } from '@nestjs/common';
import { AIMentorController } from '../controllers/ai-mentor.controller';
import { AIMentorService } from '../services/ai-mentor.service';

describe('AIMentorController', () => {
  let controller: AIMentorController;
  let mockMentorService: any;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    mockMentorService = {
      chat: jest.fn().mockResolvedValue({ summary: 'Chat OK', conversationId: 'c-1' }),
      careerMentor: jest.fn().mockResolvedValue({ summary: 'Career OK' }),
      studyMentor: jest.fn().mockResolvedValue({ summary: 'Study OK' }),
      decisionMentor: jest.fn().mockResolvedValue({ summary: 'Decision OK' }),
      productivityMentor: jest.fn().mockResolvedValue({ summary: 'Productivity OK' }),
      financeMentor: jest.fn().mockResolvedValue({ summary: 'Finance OK' }),
      getUserConversations: jest.fn().mockResolvedValue([]),
      getConversationById: jest.fn().mockResolvedValue({ id: 'c-1', title: 'Test Conv' }),
      updateConversation: jest.fn().mockResolvedValue({ id: 'c-1', isPinned: true }),
      deleteConversation: jest.fn().mockResolvedValue({ success: true }),
      submitMessageFeedback: jest.fn().mockResolvedValue({ success: true, feedbackId: 'fb-1', updated: false }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AIMentorController],
      providers: [{ provide: AIMentorService, useValue: mockMentorService }],
    }).compile();

    controller = module.get<AIMentorController>(AIMentorController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should call chat endpoint', async () => {
    const res = await controller.chat(mockUserId, { message: 'Hello AI Mentor' });
    expect(res.summary).toBe('Chat OK');
  });

  it('should call career mentor endpoint', async () => {
    const res = await controller.careerMentor(mockUserId, {});
    expect(res.summary).toBe('Career OK');
  });

  it('should call getUserConversations endpoint', async () => {
    const res = await controller.getUserConversations(mockUserId, {});
    expect(res).toEqual([]);
  });

  it('should call submitMessageFeedback with messageId param and body', async () => {
    const messageId = '22222222-2222-2222-2222-222222222222';
    const dto = { rating: 5, comment: 'Great job!' };

    const res = await controller.submitMessageFeedback(mockUserId, messageId, dto);

    expect(res.success).toBe(true);
    expect(mockMentorService.submitMessageFeedback).toHaveBeenCalledWith(mockUserId, messageId, dto);
  });

  it('should call submitChatFeedback with messageId inside dto', async () => {
    const messageId = '22222222-2222-2222-2222-222222222222';
    const dto = { messageId, rating: 4, comments: 'Helpful' };

    const res = await controller.submitChatFeedback(mockUserId, dto);

    expect(res.success).toBe(true);
    expect(mockMentorService.submitMessageFeedback).toHaveBeenCalledWith(mockUserId, messageId, dto);
  });

  it('should call updateConversation with userId, conversationId, and dto', async () => {
    const convId = '33333333-3333-3333-3333-333333333333';
    const dto = { title: 'New Conversation Title', isPinned: true };

    const res = await controller.updateConversation(mockUserId, convId, dto);

    expect(res).toEqual({ id: 'c-1', isPinned: true });
    expect(mockMentorService.updateConversation).toHaveBeenCalledWith(mockUserId, convId, dto);
  });

  it('should call deleteConversation with userId and conversationId', async () => {
    const convId = '33333333-3333-3333-3333-333333333333';

    const res = await controller.deleteConversation(mockUserId, convId);

    expect(res).toEqual({ success: true });
    expect(mockMentorService.deleteConversation).toHaveBeenCalledWith(mockUserId, convId);
  });
});

