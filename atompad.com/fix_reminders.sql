update reminders, users
set reminders.login = users.login
where users.id = reminders.user_id
