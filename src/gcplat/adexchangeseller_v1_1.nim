
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Ad Exchange Seller
## version: v1.1
## termsOfService: (not provided)
## license: (not provided)
## 
## Accesses the inventory of Ad Exchange seller users and generates reports.
## 
## https://developers.google.com/ad-exchange/seller-rest/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "adexchangeseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAccountsGet_579693 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAccountsGet_579695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsGet_579694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579821 = path.getOrDefault("accountId")
  valid_579821 = validateParameter(valid_579821, JString, required = true,
                                 default = nil)
  if valid_579821 != nil:
    section.add "accountId", valid_579821
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579822 = query.getOrDefault("fields")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "fields", valid_579822
  var valid_579823 = query.getOrDefault("quotaUser")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "quotaUser", valid_579823
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("userIp")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "userIp", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("prettyPrint")
  valid_579841 = validateParameter(valid_579841, JBool, required = false,
                                 default = newJBool(true))
  if valid_579841 != nil:
    section.add "prettyPrint", valid_579841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579864: Call_AdexchangesellerAccountsGet_579693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange account.
  ## 
  let valid = call_579864.validator(path, query, header, formData, body)
  let scheme = call_579864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579864.url(scheme.get, call_579864.host, call_579864.base,
                         call_579864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579864, url, valid)

proc call*(call_579935: Call_AdexchangesellerAccountsGet_579693; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsGet
  ## Get information about the selected Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579936 = newJObject()
  var query_579938 = newJObject()
  add(query_579938, "fields", newJString(fields))
  add(query_579938, "quotaUser", newJString(quotaUser))
  add(query_579938, "alt", newJString(alt))
  add(query_579938, "oauth_token", newJString(oauthToken))
  add(path_579936, "accountId", newJString(accountId))
  add(query_579938, "userIp", newJString(userIp))
  add(query_579938, "key", newJString(key))
  add(query_579938, "prettyPrint", newJBool(prettyPrint))
  result = call_579935.call(path_579936, query_579938, nil, nil, nil)

var adexchangesellerAccountsGet* = Call_AdexchangesellerAccountsGet_579693(
    name: "adexchangesellerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdexchangesellerAccountsGet_579694,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAccountsGet_579695,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdclientsList_579977 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdclientsList_579979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAdclientsList_579978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("pageToken")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "pageToken", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579986 = query.getOrDefault("maxResults")
  valid_579986 = validateParameter(valid_579986, JInt, required = false, default = nil)
  if valid_579986 != nil:
    section.add "maxResults", valid_579986
  var valid_579987 = query.getOrDefault("key")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "key", valid_579987
  var valid_579988 = query.getOrDefault("prettyPrint")
  valid_579988 = validateParameter(valid_579988, JBool, required = false,
                                 default = newJBool(true))
  if valid_579988 != nil:
    section.add "prettyPrint", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_AdexchangesellerAdclientsList_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_AdexchangesellerAdclientsList_579977;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdclientsList
  ## List all ad clients in this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579991 = newJObject()
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "pageToken", newJString(pageToken))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "userIp", newJString(userIp))
  add(query_579991, "maxResults", newJInt(maxResults))
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  result = call_579990.call(nil, query_579991, nil, nil, nil)

var adexchangesellerAdclientsList* = Call_AdexchangesellerAdclientsList_579977(
    name: "adexchangesellerAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdexchangesellerAdclientsList_579978,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdclientsList_579979,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsList_579992 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdunitsList_579994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAdunitsList_579993(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579995 = path.getOrDefault("adClientId")
  valid_579995 = validateParameter(valid_579995, JString, required = true,
                                 default = nil)
  if valid_579995 != nil:
    section.add "adClientId", valid_579995
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("pageToken")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "pageToken", valid_579997
  var valid_579998 = query.getOrDefault("quotaUser")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "quotaUser", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("includeInactive")
  valid_580000 = validateParameter(valid_580000, JBool, required = false, default = nil)
  if valid_580000 != nil:
    section.add "includeInactive", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("maxResults")
  valid_580003 = validateParameter(valid_580003, JInt, required = false, default = nil)
  if valid_580003 != nil:
    section.add "maxResults", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_AdexchangesellerAdunitsList_579992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_AdexchangesellerAdunitsList_579992;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; includeInactive: bool = false;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdunitsList
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "pageToken", newJString(pageToken))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "includeInactive", newJBool(includeInactive))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "maxResults", newJInt(maxResults))
  add(query_580009, "key", newJString(key))
  add(path_580008, "adClientId", newJString(adClientId))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, nil)

var adexchangesellerAdunitsList* = Call_AdexchangesellerAdunitsList_579992(
    name: "adexchangesellerAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdexchangesellerAdunitsList_579993,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdunitsList_579994,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsGet_580010 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdunitsGet_580012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAdunitsGet_580011(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580013 = path.getOrDefault("adClientId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "adClientId", valid_580013
  var valid_580014 = path.getOrDefault("adUnitId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "adUnitId", valid_580014
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("quotaUser")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "quotaUser", valid_580016
  var valid_580017 = query.getOrDefault("alt")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("json"))
  if valid_580017 != nil:
    section.add "alt", valid_580017
  var valid_580018 = query.getOrDefault("oauth_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "oauth_token", valid_580018
  var valid_580019 = query.getOrDefault("userIp")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "userIp", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_AdexchangesellerAdunitsGet_580010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_AdexchangesellerAdunitsGet_580010; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdunitsGet
  ## Gets the specified ad unit in the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "userIp", newJString(userIp))
  add(query_580025, "key", newJString(key))
  add(path_580024, "adClientId", newJString(adClientId))
  add(path_580024, "adUnitId", newJString(adUnitId))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var adexchangesellerAdunitsGet* = Call_AdexchangesellerAdunitsGet_580010(
    name: "adexchangesellerAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdexchangesellerAdunitsGet_580011,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdunitsGet_580012,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsCustomchannelsList_580026 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAdunitsCustomchannelsList_580028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAdunitsCustomchannelsList_580027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580029 = path.getOrDefault("adClientId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "adClientId", valid_580029
  var valid_580030 = path.getOrDefault("adUnitId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "adUnitId", valid_580030
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("pageToken")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "pageToken", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("userIp")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "userIp", valid_580036
  var valid_580037 = query.getOrDefault("maxResults")
  valid_580037 = validateParameter(valid_580037, JInt, required = false, default = nil)
  if valid_580037 != nil:
    section.add "maxResults", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580040: Call_AdexchangesellerAdunitsCustomchannelsList_580026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_AdexchangesellerAdunitsCustomchannelsList_580026;
          adClientId: string; adUnitId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580042 = newJObject()
  var query_580043 = newJObject()
  add(query_580043, "fields", newJString(fields))
  add(query_580043, "pageToken", newJString(pageToken))
  add(query_580043, "quotaUser", newJString(quotaUser))
  add(query_580043, "alt", newJString(alt))
  add(query_580043, "oauth_token", newJString(oauthToken))
  add(query_580043, "userIp", newJString(userIp))
  add(query_580043, "maxResults", newJInt(maxResults))
  add(query_580043, "key", newJString(key))
  add(path_580042, "adClientId", newJString(adClientId))
  add(path_580042, "adUnitId", newJString(adUnitId))
  add(query_580043, "prettyPrint", newJBool(prettyPrint))
  result = call_580041.call(path_580042, query_580043, nil, nil, nil)

var adexchangesellerAdunitsCustomchannelsList* = Call_AdexchangesellerAdunitsCustomchannelsList_580026(
    name: "adexchangesellerAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdexchangesellerAdunitsCustomchannelsList_580027,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerAdunitsCustomchannelsList_580028,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsList_580044 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerCustomchannelsList_580046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerCustomchannelsList_580045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580047 = path.getOrDefault("adClientId")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "adClientId", valid_580047
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("pageToken")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "pageToken", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("userIp")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "userIp", valid_580053
  var valid_580054 = query.getOrDefault("maxResults")
  valid_580054 = validateParameter(valid_580054, JInt, required = false, default = nil)
  if valid_580054 != nil:
    section.add "maxResults", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580057: Call_AdexchangesellerCustomchannelsList_580044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_AdexchangesellerCustomchannelsList_580044;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerCustomchannelsList
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "pageToken", newJString(pageToken))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "userIp", newJString(userIp))
  add(query_580060, "maxResults", newJInt(maxResults))
  add(query_580060, "key", newJString(key))
  add(path_580059, "adClientId", newJString(adClientId))
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580058.call(path_580059, query_580060, nil, nil, nil)

var adexchangesellerCustomchannelsList* = Call_AdexchangesellerCustomchannelsList_580044(
    name: "adexchangesellerCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerCustomchannelsList_580045,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerCustomchannelsList_580046,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsGet_580061 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerCustomchannelsGet_580063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerCustomchannelsGet_580062(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580064 = path.getOrDefault("customChannelId")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "customChannelId", valid_580064
  var valid_580065 = path.getOrDefault("adClientId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "adClientId", valid_580065
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580073: Call_AdexchangesellerCustomchannelsGet_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_580073.validator(path, query, header, formData, body)
  let scheme = call_580073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580073.url(scheme.get, call_580073.host, call_580073.base,
                         call_580073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580073, url, valid)

proc call*(call_580074: Call_AdexchangesellerCustomchannelsGet_580061;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580075 = newJObject()
  var query_580076 = newJObject()
  add(query_580076, "fields", newJString(fields))
  add(query_580076, "quotaUser", newJString(quotaUser))
  add(query_580076, "alt", newJString(alt))
  add(query_580076, "oauth_token", newJString(oauthToken))
  add(path_580075, "customChannelId", newJString(customChannelId))
  add(query_580076, "userIp", newJString(userIp))
  add(query_580076, "key", newJString(key))
  add(path_580075, "adClientId", newJString(adClientId))
  add(query_580076, "prettyPrint", newJBool(prettyPrint))
  result = call_580074.call(path_580075, query_580076, nil, nil, nil)

var adexchangesellerCustomchannelsGet* = Call_AdexchangesellerCustomchannelsGet_580061(
    name: "adexchangesellerCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerCustomchannelsGet_580062,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerCustomchannelsGet_580063,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsAdunitsList_580077 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerCustomchannelsAdunitsList_580079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerCustomchannelsAdunitsList_580078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customChannelId` field"
  var valid_580080 = path.getOrDefault("customChannelId")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "customChannelId", valid_580080
  var valid_580081 = path.getOrDefault("adClientId")
  valid_580081 = validateParameter(valid_580081, JString, required = true,
                                 default = nil)
  if valid_580081 != nil:
    section.add "adClientId", valid_580081
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("pageToken")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "pageToken", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("alt")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("json"))
  if valid_580085 != nil:
    section.add "alt", valid_580085
  var valid_580086 = query.getOrDefault("includeInactive")
  valid_580086 = validateParameter(valid_580086, JBool, required = false, default = nil)
  if valid_580086 != nil:
    section.add "includeInactive", valid_580086
  var valid_580087 = query.getOrDefault("oauth_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "oauth_token", valid_580087
  var valid_580088 = query.getOrDefault("userIp")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "userIp", valid_580088
  var valid_580089 = query.getOrDefault("maxResults")
  valid_580089 = validateParameter(valid_580089, JInt, required = false, default = nil)
  if valid_580089 != nil:
    section.add "maxResults", valid_580089
  var valid_580090 = query.getOrDefault("key")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "key", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580092: Call_AdexchangesellerCustomchannelsAdunitsList_580077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_580092.validator(path, query, header, formData, body)
  let scheme = call_580092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580092.url(scheme.get, call_580092.host, call_580092.base,
                         call_580092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580092, url, valid)

proc call*(call_580093: Call_AdexchangesellerCustomchannelsAdunitsList_580077;
          customChannelId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          includeInactive: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580094 = newJObject()
  var query_580095 = newJObject()
  add(query_580095, "fields", newJString(fields))
  add(query_580095, "pageToken", newJString(pageToken))
  add(query_580095, "quotaUser", newJString(quotaUser))
  add(query_580095, "alt", newJString(alt))
  add(query_580095, "includeInactive", newJBool(includeInactive))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(path_580094, "customChannelId", newJString(customChannelId))
  add(query_580095, "userIp", newJString(userIp))
  add(query_580095, "maxResults", newJInt(maxResults))
  add(query_580095, "key", newJString(key))
  add(path_580094, "adClientId", newJString(adClientId))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  result = call_580093.call(path_580094, query_580095, nil, nil, nil)

var adexchangesellerCustomchannelsAdunitsList* = Call_AdexchangesellerCustomchannelsAdunitsList_580077(
    name: "adexchangesellerCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdexchangesellerCustomchannelsAdunitsList_580078,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerCustomchannelsAdunitsList_580079,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerUrlchannelsList_580096 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerUrlchannelsList_580098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerUrlchannelsList_580097(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580099 = path.getOrDefault("adClientId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "adClientId", valid_580099
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("pageToken")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "pageToken", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("userIp")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "userIp", valid_580105
  var valid_580106 = query.getOrDefault("maxResults")
  valid_580106 = validateParameter(valid_580106, JInt, required = false, default = nil)
  if valid_580106 != nil:
    section.add "maxResults", valid_580106
  var valid_580107 = query.getOrDefault("key")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "key", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_AdexchangesellerUrlchannelsList_580096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_AdexchangesellerUrlchannelsList_580096;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerUrlchannelsList
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "pageToken", newJString(pageToken))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "userIp", newJString(userIp))
  add(query_580112, "maxResults", newJInt(maxResults))
  add(query_580112, "key", newJString(key))
  add(path_580111, "adClientId", newJString(adClientId))
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  result = call_580110.call(path_580111, query_580112, nil, nil, nil)

var adexchangesellerUrlchannelsList* = Call_AdexchangesellerUrlchannelsList_580096(
    name: "adexchangesellerUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerUrlchannelsList_580097,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerUrlchannelsList_580098,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAlertsList_580113 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerAlertsList_580115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAlertsList_580114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580116 = query.getOrDefault("locale")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "locale", valid_580116
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  var valid_580118 = query.getOrDefault("quotaUser")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "quotaUser", valid_580118
  var valid_580119 = query.getOrDefault("alt")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("json"))
  if valid_580119 != nil:
    section.add "alt", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("userIp")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "userIp", valid_580121
  var valid_580122 = query.getOrDefault("key")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "key", valid_580122
  var valid_580123 = query.getOrDefault("prettyPrint")
  valid_580123 = validateParameter(valid_580123, JBool, required = false,
                                 default = newJBool(true))
  if valid_580123 != nil:
    section.add "prettyPrint", valid_580123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580124: Call_AdexchangesellerAlertsList_580113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this Ad Exchange account.
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_AdexchangesellerAlertsList_580113;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAlertsList
  ## List the alerts for this Ad Exchange account.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580126 = newJObject()
  add(query_580126, "locale", newJString(locale))
  add(query_580126, "fields", newJString(fields))
  add(query_580126, "quotaUser", newJString(quotaUser))
  add(query_580126, "alt", newJString(alt))
  add(query_580126, "oauth_token", newJString(oauthToken))
  add(query_580126, "userIp", newJString(userIp))
  add(query_580126, "key", newJString(key))
  add(query_580126, "prettyPrint", newJBool(prettyPrint))
  result = call_580125.call(nil, query_580126, nil, nil, nil)

var adexchangesellerAlertsList* = Call_AdexchangesellerAlertsList_580113(
    name: "adexchangesellerAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdexchangesellerAlertsList_580114,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAlertsList_580115,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerMetadataDimensionsList_580127 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerMetadataDimensionsList_580129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerMetadataDimensionsList_580128(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("alt")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("json"))
  if valid_580132 != nil:
    section.add "alt", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_AdexchangesellerMetadataDimensionsList_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_AdexchangesellerMetadataDimensionsList_580127;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdExchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580139 = newJObject()
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "userIp", newJString(userIp))
  add(query_580139, "key", newJString(key))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  result = call_580138.call(nil, query_580139, nil, nil, nil)

var adexchangesellerMetadataDimensionsList* = Call_AdexchangesellerMetadataDimensionsList_580127(
    name: "adexchangesellerMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdexchangesellerMetadataDimensionsList_580128,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerMetadataDimensionsList_580129,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerMetadataMetricsList_580140 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerMetadataMetricsList_580142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerMetadataMetricsList_580141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580143 = query.getOrDefault("fields")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "fields", valid_580143
  var valid_580144 = query.getOrDefault("quotaUser")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "quotaUser", valid_580144
  var valid_580145 = query.getOrDefault("alt")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("json"))
  if valid_580145 != nil:
    section.add "alt", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("userIp")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "userIp", valid_580147
  var valid_580148 = query.getOrDefault("key")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "key", valid_580148
  var valid_580149 = query.getOrDefault("prettyPrint")
  valid_580149 = validateParameter(valid_580149, JBool, required = false,
                                 default = newJBool(true))
  if valid_580149 != nil:
    section.add "prettyPrint", valid_580149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580150: Call_AdexchangesellerMetadataMetricsList_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  let valid = call_580150.validator(path, query, header, formData, body)
  let scheme = call_580150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580150.url(scheme.get, call_580150.host, call_580150.base,
                         call_580150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580150, url, valid)

proc call*(call_580151: Call_AdexchangesellerMetadataMetricsList_580140;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerMetadataMetricsList
  ## List the metadata for the metrics available to this AdExchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580152 = newJObject()
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "userIp", newJString(userIp))
  add(query_580152, "key", newJString(key))
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580151.call(nil, query_580152, nil, nil, nil)

var adexchangesellerMetadataMetricsList* = Call_AdexchangesellerMetadataMetricsList_580140(
    name: "adexchangesellerMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdexchangesellerMetadataMetricsList_580141,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerMetadataMetricsList_580142,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerPreferreddealsList_580153 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerPreferreddealsList_580155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerPreferreddealsList_580154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("userIp")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "userIp", valid_580160
  var valid_580161 = query.getOrDefault("key")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "key", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580163: Call_AdexchangesellerPreferreddealsList_580153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_AdexchangesellerPreferreddealsList_580153;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerPreferreddealsList
  ## List the preferred deals for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580165 = newJObject()
  add(query_580165, "fields", newJString(fields))
  add(query_580165, "quotaUser", newJString(quotaUser))
  add(query_580165, "alt", newJString(alt))
  add(query_580165, "oauth_token", newJString(oauthToken))
  add(query_580165, "userIp", newJString(userIp))
  add(query_580165, "key", newJString(key))
  add(query_580165, "prettyPrint", newJBool(prettyPrint))
  result = call_580164.call(nil, query_580165, nil, nil, nil)

var adexchangesellerPreferreddealsList* = Call_AdexchangesellerPreferreddealsList_580153(
    name: "adexchangesellerPreferreddealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/preferreddeals",
    validator: validate_AdexchangesellerPreferreddealsList_580154,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerPreferreddealsList_580155,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerPreferreddealsGet_580166 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerPreferreddealsGet_580168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/preferreddeals/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerPreferreddealsGet_580167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dealId: JString (required)
  ##         : Preferred deal to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dealId` field"
  var valid_580169 = path.getOrDefault("dealId")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "dealId", valid_580169
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("userIp")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "userIp", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580177: Call_AdexchangesellerPreferreddealsGet_580166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  let valid = call_580177.validator(path, query, header, formData, body)
  let scheme = call_580177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580177.url(scheme.get, call_580177.host, call_580177.base,
                         call_580177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580177, url, valid)

proc call*(call_580178: Call_AdexchangesellerPreferreddealsGet_580166;
          dealId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerPreferreddealsGet
  ## Get information about the selected Ad Exchange Preferred Deal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dealId: string (required)
  ##         : Preferred deal to get information about.
  var path_580179 = newJObject()
  var query_580180 = newJObject()
  add(query_580180, "fields", newJString(fields))
  add(query_580180, "quotaUser", newJString(quotaUser))
  add(query_580180, "alt", newJString(alt))
  add(query_580180, "oauth_token", newJString(oauthToken))
  add(query_580180, "userIp", newJString(userIp))
  add(query_580180, "key", newJString(key))
  add(query_580180, "prettyPrint", newJBool(prettyPrint))
  add(path_580179, "dealId", newJString(dealId))
  result = call_580178.call(path_580179, query_580180, nil, nil, nil)

var adexchangesellerPreferreddealsGet* = Call_AdexchangesellerPreferreddealsGet_580166(
    name: "adexchangesellerPreferreddealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/preferreddeals/{dealId}",
    validator: validate_AdexchangesellerPreferreddealsGet_580167,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerPreferreddealsGet_580168,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsGenerate_580181 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerReportsGenerate_580183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsGenerate_580182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580184 = query.getOrDefault("locale")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "locale", valid_580184
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580188 = query.getOrDefault("endDate")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "endDate", valid_580188
  var valid_580189 = query.getOrDefault("startDate")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "startDate", valid_580189
  var valid_580190 = query.getOrDefault("sort")
  valid_580190 = validateParameter(valid_580190, JArray, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "sort", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("userIp")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "userIp", valid_580192
  var valid_580193 = query.getOrDefault("maxResults")
  valid_580193 = validateParameter(valid_580193, JInt, required = false, default = nil)
  if valid_580193 != nil:
    section.add "maxResults", valid_580193
  var valid_580194 = query.getOrDefault("key")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "key", valid_580194
  var valid_580195 = query.getOrDefault("metric")
  valid_580195 = validateParameter(valid_580195, JArray, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "metric", valid_580195
  var valid_580196 = query.getOrDefault("prettyPrint")
  valid_580196 = validateParameter(valid_580196, JBool, required = false,
                                 default = newJBool(true))
  if valid_580196 != nil:
    section.add "prettyPrint", valid_580196
  var valid_580197 = query.getOrDefault("dimension")
  valid_580197 = validateParameter(valid_580197, JArray, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "dimension", valid_580197
  var valid_580198 = query.getOrDefault("filter")
  valid_580198 = validateParameter(valid_580198, JArray, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "filter", valid_580198
  var valid_580199 = query.getOrDefault("startIndex")
  valid_580199 = validateParameter(valid_580199, JInt, required = false, default = nil)
  if valid_580199 != nil:
    section.add "startIndex", valid_580199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580200: Call_AdexchangesellerReportsGenerate_580181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_AdexchangesellerReportsGenerate_580181;
          endDate: string; startDate: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: JsonNode = nil;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; metric: JsonNode = nil; prettyPrint: bool = true;
          dimension: JsonNode = nil; filter: JsonNode = nil; startIndex: int = 0): Recallable =
  ## adexchangesellerReportsGenerate
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var query_580202 = newJObject()
  add(query_580202, "locale", newJString(locale))
  add(query_580202, "fields", newJString(fields))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(query_580202, "endDate", newJString(endDate))
  add(query_580202, "startDate", newJString(startDate))
  if sort != nil:
    query_580202.add "sort", sort
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(query_580202, "userIp", newJString(userIp))
  add(query_580202, "maxResults", newJInt(maxResults))
  add(query_580202, "key", newJString(key))
  if metric != nil:
    query_580202.add "metric", metric
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580202.add "dimension", dimension
  if filter != nil:
    query_580202.add "filter", filter
  add(query_580202, "startIndex", newJInt(startIndex))
  result = call_580201.call(nil, query_580202, nil, nil, nil)

var adexchangesellerReportsGenerate* = Call_AdexchangesellerReportsGenerate_580181(
    name: "adexchangesellerReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdexchangesellerReportsGenerate_580182,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsGenerate_580183,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedList_580203 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerReportsSavedList_580205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsSavedList_580204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("pageToken")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "pageToken", valid_580207
  var valid_580208 = query.getOrDefault("quotaUser")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "quotaUser", valid_580208
  var valid_580209 = query.getOrDefault("alt")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("json"))
  if valid_580209 != nil:
    section.add "alt", valid_580209
  var valid_580210 = query.getOrDefault("oauth_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "oauth_token", valid_580210
  var valid_580211 = query.getOrDefault("userIp")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "userIp", valid_580211
  var valid_580212 = query.getOrDefault("maxResults")
  valid_580212 = validateParameter(valid_580212, JInt, required = false, default = nil)
  if valid_580212 != nil:
    section.add "maxResults", valid_580212
  var valid_580213 = query.getOrDefault("key")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "key", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580215: Call_AdexchangesellerReportsSavedList_580203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_AdexchangesellerReportsSavedList_580203;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerReportsSavedList
  ## List all saved reports in this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580217 = newJObject()
  add(query_580217, "fields", newJString(fields))
  add(query_580217, "pageToken", newJString(pageToken))
  add(query_580217, "quotaUser", newJString(quotaUser))
  add(query_580217, "alt", newJString(alt))
  add(query_580217, "oauth_token", newJString(oauthToken))
  add(query_580217, "userIp", newJString(userIp))
  add(query_580217, "maxResults", newJInt(maxResults))
  add(query_580217, "key", newJString(key))
  add(query_580217, "prettyPrint", newJBool(prettyPrint))
  result = call_580216.call(nil, query_580217, nil, nil, nil)

var adexchangesellerReportsSavedList* = Call_AdexchangesellerReportsSavedList_580203(
    name: "adexchangesellerReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdexchangesellerReportsSavedList_580204,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsSavedList_580205,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedGenerate_580218 = ref object of OpenApiRestCall_579424
proc url_AdexchangesellerReportsSavedGenerate_580220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerReportsSavedGenerate_580219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedReportId` field"
  var valid_580221 = path.getOrDefault("savedReportId")
  valid_580221 = validateParameter(valid_580221, JString, required = true,
                                 default = nil)
  if valid_580221 != nil:
    section.add "savedReportId", valid_580221
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_580222 = query.getOrDefault("locale")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "locale", valid_580222
  var valid_580223 = query.getOrDefault("fields")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "fields", valid_580223
  var valid_580224 = query.getOrDefault("quotaUser")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "quotaUser", valid_580224
  var valid_580225 = query.getOrDefault("alt")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("json"))
  if valid_580225 != nil:
    section.add "alt", valid_580225
  var valid_580226 = query.getOrDefault("oauth_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "oauth_token", valid_580226
  var valid_580227 = query.getOrDefault("userIp")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "userIp", valid_580227
  var valid_580228 = query.getOrDefault("maxResults")
  valid_580228 = validateParameter(valid_580228, JInt, required = false, default = nil)
  if valid_580228 != nil:
    section.add "maxResults", valid_580228
  var valid_580229 = query.getOrDefault("key")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "key", valid_580229
  var valid_580230 = query.getOrDefault("prettyPrint")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(true))
  if valid_580230 != nil:
    section.add "prettyPrint", valid_580230
  var valid_580231 = query.getOrDefault("startIndex")
  valid_580231 = validateParameter(valid_580231, JInt, required = false, default = nil)
  if valid_580231 != nil:
    section.add "startIndex", valid_580231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580232: Call_AdexchangesellerReportsSavedGenerate_580218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_AdexchangesellerReportsSavedGenerate_580218;
          savedReportId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adexchangesellerReportsSavedGenerate
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  add(query_580235, "locale", newJString(locale))
  add(query_580235, "fields", newJString(fields))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "userIp", newJString(userIp))
  add(query_580235, "maxResults", newJInt(maxResults))
  add(path_580234, "savedReportId", newJString(savedReportId))
  add(query_580235, "key", newJString(key))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  add(query_580235, "startIndex", newJInt(startIndex))
  result = call_580233.call(path_580234, query_580235, nil, nil, nil)

var adexchangesellerReportsSavedGenerate* = Call_AdexchangesellerReportsSavedGenerate_580218(
    name: "adexchangesellerReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdexchangesellerReportsSavedGenerate_580219,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsSavedGenerate_580220,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
