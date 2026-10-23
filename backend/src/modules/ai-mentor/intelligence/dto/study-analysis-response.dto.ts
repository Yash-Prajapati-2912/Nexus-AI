import { ApiProperty } from '@nestjs/swagger';

export class SubjectPriorityDto {
  @ApiProperty({ description: 'Subject name' })
  subject: string;

  @ApiProperty({ description: 'Priority score' })
  priorityScore: number;

  @ApiProperty({ description: 'Recommended weekly focus hours' })
  recommendedHoursPerWeek: number;
}

export class StudyAnalysisResponseDto {
  @ApiProperty({ description: 'Weak subjects detected', type: [String] })
  weakSubjects: string[];

  @ApiProperty({ description: 'Subject priority scores', type: [SubjectPriorityDto] })
  subjectPriorities: SubjectPriorityDto[];

  @ApiProperty({ description: 'Exam preparation strategy' })
  examPrepStrategy: string;

  @ApiProperty({ description: 'Revision schedule guidance' })
  revisionSchedule: string;

  @ApiProperty({ description: 'Learning style optimization tips', type: [String] })
  learningStyleTips: string[];
}
