// screens/debug_jackpot_config_page.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/jackpot_config_service.dart';

class JackpotConfigPageView extends StatefulWidget {
  const JackpotConfigPageView({super.key});

  @override
  State<JackpotConfigPageView> createState() => _JackpotConfigPageViewState();
}

class _JackpotConfigPageViewState extends State<JackpotConfigPageView> {
  final JackpotConfigService _configService = JackpotConfigService();
  Map<String, dynamic>? _rawConfig;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    await _configService.reload(); // Force reload
    setState(() {
      _rawConfig = _configService.rawConfig;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rawConfig == null
              ? const Center(
                  child: Text(
                    '? Failed to load setting.json',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadConfig,
                  child: ListView(
                    padding: const EdgeInsets.only(top:200,left:50),
                    children: [
                      // Raw JSON Preview
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SelectableText(
                          const JsonEncoder.withIndent('  ')
                              .convert(_rawConfig),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Hotseat Default Values
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'Swipe down or tap ? to reload',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
    );
  }

}