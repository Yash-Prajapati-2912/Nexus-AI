import { Gender } from '../constants/gender.enum';
import { CurrentStatus } from '../constants/current-status.enum';

export interface IPublicEducation {
  institution: string;
  degree: string;
  fieldOfStudy: string;
  startDate: Date;
  endDate: Date | null;
  isCurrent: boolean;
}

export interface IPublicSkill {
  name: string;
  category: string;
  level: string;
  isVerified: boolean;
}

export interface IPublicCareerGoal {
  title: string;
  targetIndustry: string;
  targetYear: number;
}

export interface IPublicProfile {
  id: string;
  avatar: string | null;
  bio: string | null;
  country: string | null;
  state: string | null;
  city: string | null;
  university: string | null;
  degree: string | null;
  department: string | null;
  currentStatus: CurrentStatus;
  skills?: IPublicSkill[];
  education?: IPublicEducation[];
  careerGoals?: IPublicCareerGoal[];
}
