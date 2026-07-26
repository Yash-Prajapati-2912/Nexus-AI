import { Test, TestingModule } from '@nestjs/testing';
import { AIMentorController } from '../controllers/ai-mentor.controller';
import { AIMentorService } from '../services/ai-mentor.service';

describe('AIMentorController', () => {
  let controller: AIMentorController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockMentorService = {
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
});
