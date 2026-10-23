import { Injectable, Logger } from '@nestjs/common';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';
import { ReadinessLevel } from '../constants/intelligence-enums.constants';

export interface ICareerAnalysisOutput {
  targetRole: string;
  skillGaps: string[];
  readinessScore: number;
  readinessLevel: ReadinessLevel;
  resumeSuggestions: string[];
  portfolioRecommendations: string[];
  certificationSuggestions: string[];
  milestones: Array<{
    title: string;
    description: string;
    targetDays: number;
  }>;
}

@Injectable()
export class CareerEngine {
  private readonly logger = new Logger(CareerEngine.name);

  analyzeCareerReadiness(context: IAIMentorContext, targetRoleQuery?: string): ICareerAnalysisOutput {
    const targetRole = targetRoleQuery || context.userProfile?.careerGoals?.[0] || 'Software Engineer';
    const currentSkills = (context.userProfile?.skills || []).map((s) => s.toLowerCase());

    const expectedSkillsForRole: Record<string, string[]> = {
      'software engineer': ['typescript', 'node.js', 'postgresql', 'docker', 'git'],
      'ai researcher': ['python', 'pytorch', 'tensorflow', 'math', 'sql'],
      'data scientist': ['python', 'sql', 'pandas', 'statistics', 'machine learning'],
    };

    const roleKey = targetRole.toLowerCase();
    const requiredSkills = expectedSkillsForRole[roleKey] || ['problem solving', 'communication', 'technical writing', 'git'];

    const gaps = requiredSkills.filter((req) => !currentSkills.includes(req));
    const matchedCount = requiredSkills.length - gaps.length;
    const readinessScore = parseFloat(((matchedCount / Math.max(1, requiredSkills.length)) * 100).toFixed(2));

    let readinessLevel = ReadinessLevel.BEGINNER;
    if (readinessScore >= 80) readinessLevel = ReadinessLevel.JOB_READY;
    else if (readinessScore >= 50) readinessLevel = ReadinessLevel.ADVANCED;
    else if (readinessScore >= 30) readinessLevel = ReadinessLevel.INTERMEDIATE;

    return {
      targetRole,
      skillGaps: gaps.length > 0 ? gaps : ['Advanced System Architecture', 'Cloud Deployment'],
      readinessScore,
      readinessLevel,
      resumeSuggestions: [
        `Highlight practical projects using ${currentSkills.slice(0, 3).join(', ') || 'modern stacks'}`,
        'Quantify achievements with measurable percentages or user impact metrics',
      ],
      portfolioRecommendations: [
        `Build a full-stack open-source repository targeting ${targetRole}`,
        'Deploy web application with automated CI/CD pipeline and comprehensive README',
      ],
      certificationSuggestions: [
        'AWS Certified Cloud Practitioner or Developer Associate',
        'Professional Full-Stack Developer Certification',
      ],
      milestones: [
        { title: 'Close Top Skill Gap', description: `Complete hands-on project bridging ${gaps[0] || 'Cloud API integration'}`, targetDays: 14 },
        { title: 'Portfolio Project Refinement', description: 'Publish project documentation and live demonstration link', targetDays: 30 },
        { title: 'Placement / Internship Prep', description: 'Practice 20 mock technical interview problems and resume review', targetDays: 45 },
      ],
    };
  }
}
