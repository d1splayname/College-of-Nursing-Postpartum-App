from datetime import date, datetime, time, timedelta


STAGE_MILESTONES = (
    (0, "Early Recovery"),
    (2, "Building Strength"),
    (4, "Gaining Confidence"),
    (8, "Thriving Mama"),
)


def postpartum_stage(birth_date: date, today: date | None = None) -> str:
    current_date = today or date.today()
    weeks = max(0, (current_date - birth_date).days // 7)

    for start_week, stage in reversed(STAGE_MILESTONES):
        if weeks >= start_week:
            return stage
    return STAGE_MILESTONES[0][1]


def postpartum_milestones(birth_date: date) -> list[dict[str, object]]:
    milestones: list[dict[str, object]] = []
    for week, stage in STAGE_MILESTONES:
        milestone_date = birth_date + timedelta(weeks=week)
        milestones.append(
            {
                "id": None,
                "title": f"Postpartum week {week or 1}",
                "description": f"You are entering the {stage} stage.",
                "start_time": datetime.combine(milestone_date, time.min),
                "end_time": datetime.combine(milestone_date, time.max),
                "event_type": "postpartum_milestone",
                "postpartum_stage": stage,
                "source": "generated",
            }
        )
    return milestones