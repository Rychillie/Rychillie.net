import { isWithinInterval, subMonths } from 'date-fns';

export default function isWithin1Month(postDate: Date) {
  const currentDate = new Date();
  return isWithinInterval(postDate, {
    start: subMonths(currentDate, 1),
    end: currentDate
  });
}