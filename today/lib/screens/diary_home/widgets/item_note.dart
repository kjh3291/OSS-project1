import 'package:flutter/material.dart';

class ItemNote extends StatelessWidget {

  const ItemNote({Key? key, required this.color}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Text('MAY',style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white
                )),
               const SizedBox(height: 5,),
                Text('05',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white
                )),
                const SizedBox(height: 5,),
                Text('2023',style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white
                )),

              ],
            ),
          ),
         Expanded(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('This is title',style: Theme.of(context).textTheme.titleMedium),
                 const SizedBox(height: 5),
                 Text(
                   'asdfasdfasdfasdf',
                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                       color: Colors.grey
                     ),
                 )

               ],
             ),
           ),
         )
        ],
      ),
    );
  }
}
