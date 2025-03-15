#1.	Seleziona gli utenti che hanno postato almeno un video
# using nested query
select *
from users 
where id in ( 
			select user_id
			from medias
			where type='video'
			);

#using join tables
select distinct u.*
from users as u inner join medias as m on m.user_id=u.id
where m.type='video';

#2.	Seleziona tutti i post senza Like (13)
# using nested query
select *
from posts
where id not in (
				select post_id
				from likes
                );

#using join tables
select p.*
from posts as p left join likes as l on l.post_id=p.id
where l.post_id IS NULL;

#3.	Conta il numero di like per ogni post (152)
select count(*) cnt_likes
      ,p.title post_title
      ,p.id post_id
from likes as l join posts as p on l.post_id=p.id
group by p.title,p.id
order by count(*);

#4.	Ordina gli utenti per il numero di media caricati (25) 
select count(m.id) as cnt_media,u.*
from users as u  join medias as m on m.user_id=u.id
group by user_id
order by count(m.id);

#5.	Ordina gli utenti per totale di likes ricevuti nei loro posts (25) 
# se si contanto il like totali su tutti i post per ogni utente allora la query ritorna 25 records
select count(l.post_id) as cnt_likes,u.username,u.email
from users as u  
inner join likes as l on l.user_id=u.id
inner join posts as p on p.id=l.post_id
group by u.username,u.email
order by count(l.post_id);

# se il group by si fa basandosi anche sul post_id allora il query ritorna molto più records
# quanti like a preso ogni post di ogni utente
select count(l.post_id) as cnt_likes,u.username,u.email,l.post_id
from users as u  
inner join likes as l on l.user_id=u.id
inner join posts as p on p.id=l.post_id
group by u.username,u.email,l.post_id
order by count(l.post_id);
