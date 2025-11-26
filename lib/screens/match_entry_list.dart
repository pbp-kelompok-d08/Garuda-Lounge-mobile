import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/match_entry.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/screens/match_detail.dart';
import 'package:garuda_lounge_mobile/widgets/match_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MatchEntryListPage extends StatefulWidget {
  const MatchEntryListPage({super.key});

  @override
  State<MatchEntryListPage> createState() => _MatchEntryListPageState();
}

class _MatchEntryListPageState extends State<MatchEntryListPage> {
  Future<List<MatchEntry>> fetchMatch(CookieRequest request) async {
    // Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('http://localhost:8000/match/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to MatchEntry objects
    List<MatchEntry> listMatch = [];
    for (var d in data) {
      if (d != null) {
        listMatch.add(MatchEntry.fromJson(d));
      }
    }
    return listMatch;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Entry List',
          style: TextStyle(
          color: red,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),

      drawer: const LeftDrawer(),
      
      
      body: FutureBuilder(
        future: fetchMatch(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'There are no match in GarudaLounge yet.',
                    style: TextStyle(fontSize: 20, color: red),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => MatchEntryCard(
                  match: snapshot.data![index],
                  onTap: () {
                    // Navigate to news detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchDetailPage(
                          match: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}