import { Test, TestingModule } from '@nestjs/testing';
import { MentorMemoryEngineService } from '../memory/mentor-memory-engine.service';
import { ConversationMessageRepository } from '../repositories/conversation-message.repository';
import { MessageRole } from '../constants/mentor-enums.constants';

describe('MentorMemoryEngineService', () => {
  let service: MentorMemoryEngineService;
  let mockMessageRepo: { findConversationMessages: jest.Mock };

  beforeEach(async () => {
    mockMessageRepo = {
      findConversationMessages: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MentorMemoryEngineService,
        { provide: ConversationMessageRepository, useValue: mockMessageRepo },
      ],
    }).compile();

    service = module.get<MentorMemoryEngineService>(MentorMemoryEngineService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should return empty list when no conversation turns exist', async () => {
    mockMessageRepo.findConversationMessages.mockResolvedValue([]);
    const memory = await service.getShortTermMemory('c-1', 6);
    expect(memory).toEqual([]);
    expect(mockMessageRepo.findConversationMessages).toHaveBeenCalledWith('c-1', 6);
  });

  it('should correctly map userMessage for USER and aiResponse.summary for ASSISTANT', async () => {
    mockMessageRepo.findConversationMessages.mockResolvedValue([
      {
        id: 'm-1',
        conversationId: 'c-1',
        role: MessageRole.USER,
        userMessage: 'How do I prepare for exams?',
        aiResponse: null,
      },
      {
        id: 'm-2',
        conversationId: 'c-1',
        role: MessageRole.ASSISTANT,
        userMessage: 'How do I prepare for exams?',
        aiResponse: {
          summary: 'Create a structured study schedule and take active breaks.',
          recommendations: [{ title: 'Focus 45 min' }],
        },
      },
      {
        id: 'm-3',
        conversationId: 'c-1',
        role: MessageRole.USER,
        userMessage: 'What about math specifically?',
        aiResponse: null,
      },
    ]);

    const memory = await service.getShortTermMemory('c-1', 6);

    expect(memory).toHaveLength(3);
    expect(memory[0]).toEqual({
      role: MessageRole.USER,
      text: 'How do I prepare for exams?',
    });
    expect(memory[1]).toEqual({
      role: MessageRole.ASSISTANT,
      text: 'Create a structured study schedule and take active breaks.',
    });
    expect(memory[2]).toEqual({
      role: MessageRole.USER,
      text: 'What about math specifically?',
    });
  });

  it('should safely fallback if aiResponse is missing or malformed', async () => {
    mockMessageRepo.findConversationMessages.mockResolvedValue([
      {
        id: 'm-1',
        conversationId: 'c-1',
        role: MessageRole.ASSISTANT,
        userMessage: 'Previous fallback prompt',
        aiResponse: null,
      },
      {
        id: 'm-2',
        conversationId: 'c-1',
        role: MessageRole.ASSISTANT,
        userMessage: '',
        aiResponse: 'Plain string assistant response',
      },
    ]);

    const memory = await service.getShortTermMemory('c-1', 6);

    expect(memory).toHaveLength(2);
    expect(memory[0].text).toBe('Previous fallback prompt');
    expect(memory[1].text).toBe('Plain string assistant response');
  });
});
