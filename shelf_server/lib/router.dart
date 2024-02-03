import 'package:shelf_router/shelf_router.dart';

import 'route_handlers.dart';

final router = Router()
  ..post('/create', createHandler)
  ..get('/read', readHandler)
  ..put('/update', updateHandler)
  ..delete('/delete/<id>', deleteHandler);
