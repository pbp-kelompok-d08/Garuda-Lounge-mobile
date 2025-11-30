import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/merch_entry.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/screens/merch_detail.dart';
import 'package:garuda_lounge_mobile/widgets/merch_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MerchEntryListPage extends StatefulWidget {
  const MerchEntryListPage({super.key});

  @override
  State<MerchEntryListPage> createState() => _MerchEntryListPageState();
}

class _MerchEntryListPageState extends State<MerchEntryListPage> {
  Future<List<MerchEntry>> fetchMerch(CookieRequest request) async {
    // TODO: Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('http://localhost:8000/merchandise/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to MerchEntry objects
    List<MerchEntry> listMerch = [];
    for (var d in data) {
      if (d != null) {
        listMerch.add(MerchEntry.fromJson(d));
      }
    }
    return listMerch;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merch Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMerch(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'There are no merch in here yet.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => MerchEntryCard(
                  merch: snapshot.data![index],
                  onTap: () {
                    // Show a snackbar when merch card is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MerchDetailPage(
                          merch: snapshot.data![index],
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