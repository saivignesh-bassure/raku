unit module Meetup;

sub meetup-date (Str:D $desc --> Date:D) is export {
  my (Date $date, Str $day-of-week);
  given $desc.words {
    $date = Date.new: year => .[*-1];

    given .[*-2] {
      $date.=later: months => %(<
        January February March     April   May      June
        July    August   September October November December
      >.antipairs){$_}
    }

    $day-of-week = S/day// given .[1].lc;
    $date.=later: days => (given .[0] {
      when 'First'   { 0}
      when 'Second'  { 7}
      when 'Third'   {14}
      when 'Fourth'  {21}
      when 'Teenth'  {12}
      when 'Last'    {$date.=later(:1month); -7}
    });
  }

  $date.=succ until $date.day-of-week == (given <
    mon tues
    wednes thurs
    fri satur sun
  > {
    %(.values Z=> .keys »+» 1){$day-of-week}
  });

  return $date;
}
