@prod

Narrative:
Relevancy ranking is putting archival items ahead of the collections.
We should adjust indexing so that archival items are listed last,
after collections and all other formats.

Given I am on the home page
And I fill in q with "Freed"
When I press search
Then I should see "Guide to the Alan Freed Collection (ARC.0006)"
And I should see "Big beat heat : Alan Freed and the early years of rock & roll / John A."
And I should see "Guide to the Collection on Alan Freed (Rock and Roll Hall of Fame and Museum Collection) (ARC.0296)"