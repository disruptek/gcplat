
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAccountsGet_597693 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsGet_597695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsGet_597694(path: JsonNode; query: JsonNode;
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
  var valid_597821 = path.getOrDefault("accountId")
  valid_597821 = validateParameter(valid_597821, JString, required = true,
                                 default = nil)
  if valid_597821 != nil:
    section.add "accountId", valid_597821
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
  var valid_597822 = query.getOrDefault("fields")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "fields", valid_597822
  var valid_597823 = query.getOrDefault("quotaUser")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "quotaUser", valid_597823
  var valid_597837 = query.getOrDefault("alt")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = newJString("json"))
  if valid_597837 != nil:
    section.add "alt", valid_597837
  var valid_597838 = query.getOrDefault("oauth_token")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "oauth_token", valid_597838
  var valid_597839 = query.getOrDefault("userIp")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "userIp", valid_597839
  var valid_597840 = query.getOrDefault("key")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "key", valid_597840
  var valid_597841 = query.getOrDefault("prettyPrint")
  valid_597841 = validateParameter(valid_597841, JBool, required = false,
                                 default = newJBool(true))
  if valid_597841 != nil:
    section.add "prettyPrint", valid_597841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597864: Call_AdexchangesellerAccountsGet_597693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange account.
  ## 
  let valid = call_597864.validator(path, query, header, formData, body)
  let scheme = call_597864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597864.url(scheme.get, call_597864.host, call_597864.base,
                         call_597864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597864, url, valid)

proc call*(call_597935: Call_AdexchangesellerAccountsGet_597693; accountId: string;
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
  var path_597936 = newJObject()
  var query_597938 = newJObject()
  add(query_597938, "fields", newJString(fields))
  add(query_597938, "quotaUser", newJString(quotaUser))
  add(query_597938, "alt", newJString(alt))
  add(query_597938, "oauth_token", newJString(oauthToken))
  add(path_597936, "accountId", newJString(accountId))
  add(query_597938, "userIp", newJString(userIp))
  add(query_597938, "key", newJString(key))
  add(query_597938, "prettyPrint", newJBool(prettyPrint))
  result = call_597935.call(path_597936, query_597938, nil, nil, nil)

var adexchangesellerAccountsGet* = Call_AdexchangesellerAccountsGet_597693(
    name: "adexchangesellerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdexchangesellerAccountsGet_597694,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAccountsGet_597695,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdclientsList_597977 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdclientsList_597979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerAdclientsList_597978(path: JsonNode; query: JsonNode;
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
  var valid_597980 = query.getOrDefault("fields")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "fields", valid_597980
  var valid_597981 = query.getOrDefault("pageToken")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "pageToken", valid_597981
  var valid_597982 = query.getOrDefault("quotaUser")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "quotaUser", valid_597982
  var valid_597983 = query.getOrDefault("alt")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = newJString("json"))
  if valid_597983 != nil:
    section.add "alt", valid_597983
  var valid_597984 = query.getOrDefault("oauth_token")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "oauth_token", valid_597984
  var valid_597985 = query.getOrDefault("userIp")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "userIp", valid_597985
  var valid_597986 = query.getOrDefault("maxResults")
  valid_597986 = validateParameter(valid_597986, JInt, required = false, default = nil)
  if valid_597986 != nil:
    section.add "maxResults", valid_597986
  var valid_597987 = query.getOrDefault("key")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "key", valid_597987
  var valid_597988 = query.getOrDefault("prettyPrint")
  valid_597988 = validateParameter(valid_597988, JBool, required = false,
                                 default = newJBool(true))
  if valid_597988 != nil:
    section.add "prettyPrint", valid_597988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597989: Call_AdexchangesellerAdclientsList_597977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_597989.validator(path, query, header, formData, body)
  let scheme = call_597989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597989.url(scheme.get, call_597989.host, call_597989.base,
                         call_597989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597989, url, valid)

proc call*(call_597990: Call_AdexchangesellerAdclientsList_597977;
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
  var query_597991 = newJObject()
  add(query_597991, "fields", newJString(fields))
  add(query_597991, "pageToken", newJString(pageToken))
  add(query_597991, "quotaUser", newJString(quotaUser))
  add(query_597991, "alt", newJString(alt))
  add(query_597991, "oauth_token", newJString(oauthToken))
  add(query_597991, "userIp", newJString(userIp))
  add(query_597991, "maxResults", newJInt(maxResults))
  add(query_597991, "key", newJString(key))
  add(query_597991, "prettyPrint", newJBool(prettyPrint))
  result = call_597990.call(nil, query_597991, nil, nil, nil)

var adexchangesellerAdclientsList* = Call_AdexchangesellerAdclientsList_597977(
    name: "adexchangesellerAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdexchangesellerAdclientsList_597978,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdclientsList_597979,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsList_597992 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdunitsList_597994(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerAdunitsList_597993(path: JsonNode; query: JsonNode;
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
  var valid_597995 = path.getOrDefault("adClientId")
  valid_597995 = validateParameter(valid_597995, JString, required = true,
                                 default = nil)
  if valid_597995 != nil:
    section.add "adClientId", valid_597995
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
  var valid_597996 = query.getOrDefault("fields")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "fields", valid_597996
  var valid_597997 = query.getOrDefault("pageToken")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "pageToken", valid_597997
  var valid_597998 = query.getOrDefault("quotaUser")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "quotaUser", valid_597998
  var valid_597999 = query.getOrDefault("alt")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("json"))
  if valid_597999 != nil:
    section.add "alt", valid_597999
  var valid_598000 = query.getOrDefault("includeInactive")
  valid_598000 = validateParameter(valid_598000, JBool, required = false, default = nil)
  if valid_598000 != nil:
    section.add "includeInactive", valid_598000
  var valid_598001 = query.getOrDefault("oauth_token")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "oauth_token", valid_598001
  var valid_598002 = query.getOrDefault("userIp")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "userIp", valid_598002
  var valid_598003 = query.getOrDefault("maxResults")
  valid_598003 = validateParameter(valid_598003, JInt, required = false, default = nil)
  if valid_598003 != nil:
    section.add "maxResults", valid_598003
  var valid_598004 = query.getOrDefault("key")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "key", valid_598004
  var valid_598005 = query.getOrDefault("prettyPrint")
  valid_598005 = validateParameter(valid_598005, JBool, required = false,
                                 default = newJBool(true))
  if valid_598005 != nil:
    section.add "prettyPrint", valid_598005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598006: Call_AdexchangesellerAdunitsList_597992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598006.validator(path, query, header, formData, body)
  let scheme = call_598006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598006.url(scheme.get, call_598006.host, call_598006.base,
                         call_598006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598006, url, valid)

proc call*(call_598007: Call_AdexchangesellerAdunitsList_597992;
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
  var path_598008 = newJObject()
  var query_598009 = newJObject()
  add(query_598009, "fields", newJString(fields))
  add(query_598009, "pageToken", newJString(pageToken))
  add(query_598009, "quotaUser", newJString(quotaUser))
  add(query_598009, "alt", newJString(alt))
  add(query_598009, "includeInactive", newJBool(includeInactive))
  add(query_598009, "oauth_token", newJString(oauthToken))
  add(query_598009, "userIp", newJString(userIp))
  add(query_598009, "maxResults", newJInt(maxResults))
  add(query_598009, "key", newJString(key))
  add(path_598008, "adClientId", newJString(adClientId))
  add(query_598009, "prettyPrint", newJBool(prettyPrint))
  result = call_598007.call(path_598008, query_598009, nil, nil, nil)

var adexchangesellerAdunitsList* = Call_AdexchangesellerAdunitsList_597992(
    name: "adexchangesellerAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdexchangesellerAdunitsList_597993,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdunitsList_597994,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsGet_598010 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdunitsGet_598012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerAdunitsGet_598011(path: JsonNode; query: JsonNode;
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
  var valid_598013 = path.getOrDefault("adClientId")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "adClientId", valid_598013
  var valid_598014 = path.getOrDefault("adUnitId")
  valid_598014 = validateParameter(valid_598014, JString, required = true,
                                 default = nil)
  if valid_598014 != nil:
    section.add "adUnitId", valid_598014
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
  var valid_598015 = query.getOrDefault("fields")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "fields", valid_598015
  var valid_598016 = query.getOrDefault("quotaUser")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "quotaUser", valid_598016
  var valid_598017 = query.getOrDefault("alt")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = newJString("json"))
  if valid_598017 != nil:
    section.add "alt", valid_598017
  var valid_598018 = query.getOrDefault("oauth_token")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "oauth_token", valid_598018
  var valid_598019 = query.getOrDefault("userIp")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "userIp", valid_598019
  var valid_598020 = query.getOrDefault("key")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "key", valid_598020
  var valid_598021 = query.getOrDefault("prettyPrint")
  valid_598021 = validateParameter(valid_598021, JBool, required = false,
                                 default = newJBool(true))
  if valid_598021 != nil:
    section.add "prettyPrint", valid_598021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598022: Call_AdexchangesellerAdunitsGet_598010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_AdexchangesellerAdunitsGet_598010; adClientId: string;
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
  var path_598024 = newJObject()
  var query_598025 = newJObject()
  add(query_598025, "fields", newJString(fields))
  add(query_598025, "quotaUser", newJString(quotaUser))
  add(query_598025, "alt", newJString(alt))
  add(query_598025, "oauth_token", newJString(oauthToken))
  add(query_598025, "userIp", newJString(userIp))
  add(query_598025, "key", newJString(key))
  add(path_598024, "adClientId", newJString(adClientId))
  add(path_598024, "adUnitId", newJString(adUnitId))
  add(query_598025, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(path_598024, query_598025, nil, nil, nil)

var adexchangesellerAdunitsGet* = Call_AdexchangesellerAdunitsGet_598010(
    name: "adexchangesellerAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdexchangesellerAdunitsGet_598011,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdunitsGet_598012,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsCustomchannelsList_598026 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAdunitsCustomchannelsList_598028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerAdunitsCustomchannelsList_598027(path: JsonNode;
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
  var valid_598029 = path.getOrDefault("adClientId")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "adClientId", valid_598029
  var valid_598030 = path.getOrDefault("adUnitId")
  valid_598030 = validateParameter(valid_598030, JString, required = true,
                                 default = nil)
  if valid_598030 != nil:
    section.add "adUnitId", valid_598030
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
  var valid_598031 = query.getOrDefault("fields")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "fields", valid_598031
  var valid_598032 = query.getOrDefault("pageToken")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "pageToken", valid_598032
  var valid_598033 = query.getOrDefault("quotaUser")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "quotaUser", valid_598033
  var valid_598034 = query.getOrDefault("alt")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("json"))
  if valid_598034 != nil:
    section.add "alt", valid_598034
  var valid_598035 = query.getOrDefault("oauth_token")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "oauth_token", valid_598035
  var valid_598036 = query.getOrDefault("userIp")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "userIp", valid_598036
  var valid_598037 = query.getOrDefault("maxResults")
  valid_598037 = validateParameter(valid_598037, JInt, required = false, default = nil)
  if valid_598037 != nil:
    section.add "maxResults", valid_598037
  var valid_598038 = query.getOrDefault("key")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "key", valid_598038
  var valid_598039 = query.getOrDefault("prettyPrint")
  valid_598039 = validateParameter(valid_598039, JBool, required = false,
                                 default = newJBool(true))
  if valid_598039 != nil:
    section.add "prettyPrint", valid_598039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598040: Call_AdexchangesellerAdunitsCustomchannelsList_598026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_AdexchangesellerAdunitsCustomchannelsList_598026;
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
  var path_598042 = newJObject()
  var query_598043 = newJObject()
  add(query_598043, "fields", newJString(fields))
  add(query_598043, "pageToken", newJString(pageToken))
  add(query_598043, "quotaUser", newJString(quotaUser))
  add(query_598043, "alt", newJString(alt))
  add(query_598043, "oauth_token", newJString(oauthToken))
  add(query_598043, "userIp", newJString(userIp))
  add(query_598043, "maxResults", newJInt(maxResults))
  add(query_598043, "key", newJString(key))
  add(path_598042, "adClientId", newJString(adClientId))
  add(path_598042, "adUnitId", newJString(adUnitId))
  add(query_598043, "prettyPrint", newJBool(prettyPrint))
  result = call_598041.call(path_598042, query_598043, nil, nil, nil)

var adexchangesellerAdunitsCustomchannelsList* = Call_AdexchangesellerAdunitsCustomchannelsList_598026(
    name: "adexchangesellerAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdexchangesellerAdunitsCustomchannelsList_598027,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerAdunitsCustomchannelsList_598028,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsList_598044 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerCustomchannelsList_598046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerCustomchannelsList_598045(path: JsonNode;
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
  var valid_598047 = path.getOrDefault("adClientId")
  valid_598047 = validateParameter(valid_598047, JString, required = true,
                                 default = nil)
  if valid_598047 != nil:
    section.add "adClientId", valid_598047
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
  var valid_598048 = query.getOrDefault("fields")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "fields", valid_598048
  var valid_598049 = query.getOrDefault("pageToken")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "pageToken", valid_598049
  var valid_598050 = query.getOrDefault("quotaUser")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "quotaUser", valid_598050
  var valid_598051 = query.getOrDefault("alt")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = newJString("json"))
  if valid_598051 != nil:
    section.add "alt", valid_598051
  var valid_598052 = query.getOrDefault("oauth_token")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "oauth_token", valid_598052
  var valid_598053 = query.getOrDefault("userIp")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "userIp", valid_598053
  var valid_598054 = query.getOrDefault("maxResults")
  valid_598054 = validateParameter(valid_598054, JInt, required = false, default = nil)
  if valid_598054 != nil:
    section.add "maxResults", valid_598054
  var valid_598055 = query.getOrDefault("key")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "key", valid_598055
  var valid_598056 = query.getOrDefault("prettyPrint")
  valid_598056 = validateParameter(valid_598056, JBool, required = false,
                                 default = newJBool(true))
  if valid_598056 != nil:
    section.add "prettyPrint", valid_598056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598057: Call_AdexchangesellerCustomchannelsList_598044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598057.validator(path, query, header, formData, body)
  let scheme = call_598057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598057.url(scheme.get, call_598057.host, call_598057.base,
                         call_598057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598057, url, valid)

proc call*(call_598058: Call_AdexchangesellerCustomchannelsList_598044;
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
  var path_598059 = newJObject()
  var query_598060 = newJObject()
  add(query_598060, "fields", newJString(fields))
  add(query_598060, "pageToken", newJString(pageToken))
  add(query_598060, "quotaUser", newJString(quotaUser))
  add(query_598060, "alt", newJString(alt))
  add(query_598060, "oauth_token", newJString(oauthToken))
  add(query_598060, "userIp", newJString(userIp))
  add(query_598060, "maxResults", newJInt(maxResults))
  add(query_598060, "key", newJString(key))
  add(path_598059, "adClientId", newJString(adClientId))
  add(query_598060, "prettyPrint", newJBool(prettyPrint))
  result = call_598058.call(path_598059, query_598060, nil, nil, nil)

var adexchangesellerCustomchannelsList* = Call_AdexchangesellerCustomchannelsList_598044(
    name: "adexchangesellerCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerCustomchannelsList_598045,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerCustomchannelsList_598046,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsGet_598061 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerCustomchannelsGet_598063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerCustomchannelsGet_598062(path: JsonNode;
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
  var valid_598064 = path.getOrDefault("customChannelId")
  valid_598064 = validateParameter(valid_598064, JString, required = true,
                                 default = nil)
  if valid_598064 != nil:
    section.add "customChannelId", valid_598064
  var valid_598065 = path.getOrDefault("adClientId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "adClientId", valid_598065
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
  var valid_598066 = query.getOrDefault("fields")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "fields", valid_598066
  var valid_598067 = query.getOrDefault("quotaUser")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "quotaUser", valid_598067
  var valid_598068 = query.getOrDefault("alt")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = newJString("json"))
  if valid_598068 != nil:
    section.add "alt", valid_598068
  var valid_598069 = query.getOrDefault("oauth_token")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "oauth_token", valid_598069
  var valid_598070 = query.getOrDefault("userIp")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "userIp", valid_598070
  var valid_598071 = query.getOrDefault("key")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "key", valid_598071
  var valid_598072 = query.getOrDefault("prettyPrint")
  valid_598072 = validateParameter(valid_598072, JBool, required = false,
                                 default = newJBool(true))
  if valid_598072 != nil:
    section.add "prettyPrint", valid_598072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598073: Call_AdexchangesellerCustomchannelsGet_598061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_598073.validator(path, query, header, formData, body)
  let scheme = call_598073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598073.url(scheme.get, call_598073.host, call_598073.base,
                         call_598073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598073, url, valid)

proc call*(call_598074: Call_AdexchangesellerCustomchannelsGet_598061;
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
  var path_598075 = newJObject()
  var query_598076 = newJObject()
  add(query_598076, "fields", newJString(fields))
  add(query_598076, "quotaUser", newJString(quotaUser))
  add(query_598076, "alt", newJString(alt))
  add(query_598076, "oauth_token", newJString(oauthToken))
  add(path_598075, "customChannelId", newJString(customChannelId))
  add(query_598076, "userIp", newJString(userIp))
  add(query_598076, "key", newJString(key))
  add(path_598075, "adClientId", newJString(adClientId))
  add(query_598076, "prettyPrint", newJBool(prettyPrint))
  result = call_598074.call(path_598075, query_598076, nil, nil, nil)

var adexchangesellerCustomchannelsGet* = Call_AdexchangesellerCustomchannelsGet_598061(
    name: "adexchangesellerCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerCustomchannelsGet_598062,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerCustomchannelsGet_598063,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsAdunitsList_598077 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerCustomchannelsAdunitsList_598079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerCustomchannelsAdunitsList_598078(path: JsonNode;
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
  var valid_598080 = path.getOrDefault("customChannelId")
  valid_598080 = validateParameter(valid_598080, JString, required = true,
                                 default = nil)
  if valid_598080 != nil:
    section.add "customChannelId", valid_598080
  var valid_598081 = path.getOrDefault("adClientId")
  valid_598081 = validateParameter(valid_598081, JString, required = true,
                                 default = nil)
  if valid_598081 != nil:
    section.add "adClientId", valid_598081
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
  var valid_598082 = query.getOrDefault("fields")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "fields", valid_598082
  var valid_598083 = query.getOrDefault("pageToken")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "pageToken", valid_598083
  var valid_598084 = query.getOrDefault("quotaUser")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "quotaUser", valid_598084
  var valid_598085 = query.getOrDefault("alt")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = newJString("json"))
  if valid_598085 != nil:
    section.add "alt", valid_598085
  var valid_598086 = query.getOrDefault("includeInactive")
  valid_598086 = validateParameter(valid_598086, JBool, required = false, default = nil)
  if valid_598086 != nil:
    section.add "includeInactive", valid_598086
  var valid_598087 = query.getOrDefault("oauth_token")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "oauth_token", valid_598087
  var valid_598088 = query.getOrDefault("userIp")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "userIp", valid_598088
  var valid_598089 = query.getOrDefault("maxResults")
  valid_598089 = validateParameter(valid_598089, JInt, required = false, default = nil)
  if valid_598089 != nil:
    section.add "maxResults", valid_598089
  var valid_598090 = query.getOrDefault("key")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "key", valid_598090
  var valid_598091 = query.getOrDefault("prettyPrint")
  valid_598091 = validateParameter(valid_598091, JBool, required = false,
                                 default = newJBool(true))
  if valid_598091 != nil:
    section.add "prettyPrint", valid_598091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598092: Call_AdexchangesellerCustomchannelsAdunitsList_598077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_598092.validator(path, query, header, formData, body)
  let scheme = call_598092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598092.url(scheme.get, call_598092.host, call_598092.base,
                         call_598092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598092, url, valid)

proc call*(call_598093: Call_AdexchangesellerCustomchannelsAdunitsList_598077;
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
  var path_598094 = newJObject()
  var query_598095 = newJObject()
  add(query_598095, "fields", newJString(fields))
  add(query_598095, "pageToken", newJString(pageToken))
  add(query_598095, "quotaUser", newJString(quotaUser))
  add(query_598095, "alt", newJString(alt))
  add(query_598095, "includeInactive", newJBool(includeInactive))
  add(query_598095, "oauth_token", newJString(oauthToken))
  add(path_598094, "customChannelId", newJString(customChannelId))
  add(query_598095, "userIp", newJString(userIp))
  add(query_598095, "maxResults", newJInt(maxResults))
  add(query_598095, "key", newJString(key))
  add(path_598094, "adClientId", newJString(adClientId))
  add(query_598095, "prettyPrint", newJBool(prettyPrint))
  result = call_598093.call(path_598094, query_598095, nil, nil, nil)

var adexchangesellerCustomchannelsAdunitsList* = Call_AdexchangesellerCustomchannelsAdunitsList_598077(
    name: "adexchangesellerCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdexchangesellerCustomchannelsAdunitsList_598078,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerCustomchannelsAdunitsList_598079,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerUrlchannelsList_598096 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerUrlchannelsList_598098(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdexchangesellerUrlchannelsList_598097(path: JsonNode;
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
  var valid_598099 = path.getOrDefault("adClientId")
  valid_598099 = validateParameter(valid_598099, JString, required = true,
                                 default = nil)
  if valid_598099 != nil:
    section.add "adClientId", valid_598099
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
  var valid_598100 = query.getOrDefault("fields")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "fields", valid_598100
  var valid_598101 = query.getOrDefault("pageToken")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "pageToken", valid_598101
  var valid_598102 = query.getOrDefault("quotaUser")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "quotaUser", valid_598102
  var valid_598103 = query.getOrDefault("alt")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = newJString("json"))
  if valid_598103 != nil:
    section.add "alt", valid_598103
  var valid_598104 = query.getOrDefault("oauth_token")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "oauth_token", valid_598104
  var valid_598105 = query.getOrDefault("userIp")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "userIp", valid_598105
  var valid_598106 = query.getOrDefault("maxResults")
  valid_598106 = validateParameter(valid_598106, JInt, required = false, default = nil)
  if valid_598106 != nil:
    section.add "maxResults", valid_598106
  var valid_598107 = query.getOrDefault("key")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "key", valid_598107
  var valid_598108 = query.getOrDefault("prettyPrint")
  valid_598108 = validateParameter(valid_598108, JBool, required = false,
                                 default = newJBool(true))
  if valid_598108 != nil:
    section.add "prettyPrint", valid_598108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598109: Call_AdexchangesellerUrlchannelsList_598096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598109.validator(path, query, header, formData, body)
  let scheme = call_598109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598109.url(scheme.get, call_598109.host, call_598109.base,
                         call_598109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598109, url, valid)

proc call*(call_598110: Call_AdexchangesellerUrlchannelsList_598096;
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
  var path_598111 = newJObject()
  var query_598112 = newJObject()
  add(query_598112, "fields", newJString(fields))
  add(query_598112, "pageToken", newJString(pageToken))
  add(query_598112, "quotaUser", newJString(quotaUser))
  add(query_598112, "alt", newJString(alt))
  add(query_598112, "oauth_token", newJString(oauthToken))
  add(query_598112, "userIp", newJString(userIp))
  add(query_598112, "maxResults", newJInt(maxResults))
  add(query_598112, "key", newJString(key))
  add(path_598111, "adClientId", newJString(adClientId))
  add(query_598112, "prettyPrint", newJBool(prettyPrint))
  result = call_598110.call(path_598111, query_598112, nil, nil, nil)

var adexchangesellerUrlchannelsList* = Call_AdexchangesellerUrlchannelsList_598096(
    name: "adexchangesellerUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerUrlchannelsList_598097,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerUrlchannelsList_598098,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAlertsList_598113 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAlertsList_598115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerAlertsList_598114(path: JsonNode; query: JsonNode;
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
  var valid_598116 = query.getOrDefault("locale")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "locale", valid_598116
  var valid_598117 = query.getOrDefault("fields")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "fields", valid_598117
  var valid_598118 = query.getOrDefault("quotaUser")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "quotaUser", valid_598118
  var valid_598119 = query.getOrDefault("alt")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = newJString("json"))
  if valid_598119 != nil:
    section.add "alt", valid_598119
  var valid_598120 = query.getOrDefault("oauth_token")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "oauth_token", valid_598120
  var valid_598121 = query.getOrDefault("userIp")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "userIp", valid_598121
  var valid_598122 = query.getOrDefault("key")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "key", valid_598122
  var valid_598123 = query.getOrDefault("prettyPrint")
  valid_598123 = validateParameter(valid_598123, JBool, required = false,
                                 default = newJBool(true))
  if valid_598123 != nil:
    section.add "prettyPrint", valid_598123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598124: Call_AdexchangesellerAlertsList_598113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this Ad Exchange account.
  ## 
  let valid = call_598124.validator(path, query, header, formData, body)
  let scheme = call_598124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598124.url(scheme.get, call_598124.host, call_598124.base,
                         call_598124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598124, url, valid)

proc call*(call_598125: Call_AdexchangesellerAlertsList_598113;
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
  var query_598126 = newJObject()
  add(query_598126, "locale", newJString(locale))
  add(query_598126, "fields", newJString(fields))
  add(query_598126, "quotaUser", newJString(quotaUser))
  add(query_598126, "alt", newJString(alt))
  add(query_598126, "oauth_token", newJString(oauthToken))
  add(query_598126, "userIp", newJString(userIp))
  add(query_598126, "key", newJString(key))
  add(query_598126, "prettyPrint", newJBool(prettyPrint))
  result = call_598125.call(nil, query_598126, nil, nil, nil)

var adexchangesellerAlertsList* = Call_AdexchangesellerAlertsList_598113(
    name: "adexchangesellerAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdexchangesellerAlertsList_598114,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAlertsList_598115,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerMetadataDimensionsList_598127 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerMetadataDimensionsList_598129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerMetadataDimensionsList_598128(path: JsonNode;
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
  var valid_598130 = query.getOrDefault("fields")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "fields", valid_598130
  var valid_598131 = query.getOrDefault("quotaUser")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "quotaUser", valid_598131
  var valid_598132 = query.getOrDefault("alt")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = newJString("json"))
  if valid_598132 != nil:
    section.add "alt", valid_598132
  var valid_598133 = query.getOrDefault("oauth_token")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "oauth_token", valid_598133
  var valid_598134 = query.getOrDefault("userIp")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "userIp", valid_598134
  var valid_598135 = query.getOrDefault("key")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "key", valid_598135
  var valid_598136 = query.getOrDefault("prettyPrint")
  valid_598136 = validateParameter(valid_598136, JBool, required = false,
                                 default = newJBool(true))
  if valid_598136 != nil:
    section.add "prettyPrint", valid_598136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598137: Call_AdexchangesellerMetadataDimensionsList_598127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  let valid = call_598137.validator(path, query, header, formData, body)
  let scheme = call_598137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598137.url(scheme.get, call_598137.host, call_598137.base,
                         call_598137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598137, url, valid)

proc call*(call_598138: Call_AdexchangesellerMetadataDimensionsList_598127;
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
  var query_598139 = newJObject()
  add(query_598139, "fields", newJString(fields))
  add(query_598139, "quotaUser", newJString(quotaUser))
  add(query_598139, "alt", newJString(alt))
  add(query_598139, "oauth_token", newJString(oauthToken))
  add(query_598139, "userIp", newJString(userIp))
  add(query_598139, "key", newJString(key))
  add(query_598139, "prettyPrint", newJBool(prettyPrint))
  result = call_598138.call(nil, query_598139, nil, nil, nil)

var adexchangesellerMetadataDimensionsList* = Call_AdexchangesellerMetadataDimensionsList_598127(
    name: "adexchangesellerMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdexchangesellerMetadataDimensionsList_598128,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerMetadataDimensionsList_598129,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerMetadataMetricsList_598140 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerMetadataMetricsList_598142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerMetadataMetricsList_598141(path: JsonNode;
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
  var valid_598143 = query.getOrDefault("fields")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "fields", valid_598143
  var valid_598144 = query.getOrDefault("quotaUser")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "quotaUser", valid_598144
  var valid_598145 = query.getOrDefault("alt")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = newJString("json"))
  if valid_598145 != nil:
    section.add "alt", valid_598145
  var valid_598146 = query.getOrDefault("oauth_token")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "oauth_token", valid_598146
  var valid_598147 = query.getOrDefault("userIp")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "userIp", valid_598147
  var valid_598148 = query.getOrDefault("key")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "key", valid_598148
  var valid_598149 = query.getOrDefault("prettyPrint")
  valid_598149 = validateParameter(valid_598149, JBool, required = false,
                                 default = newJBool(true))
  if valid_598149 != nil:
    section.add "prettyPrint", valid_598149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598150: Call_AdexchangesellerMetadataMetricsList_598140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  let valid = call_598150.validator(path, query, header, formData, body)
  let scheme = call_598150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598150.url(scheme.get, call_598150.host, call_598150.base,
                         call_598150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598150, url, valid)

proc call*(call_598151: Call_AdexchangesellerMetadataMetricsList_598140;
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
  var query_598152 = newJObject()
  add(query_598152, "fields", newJString(fields))
  add(query_598152, "quotaUser", newJString(quotaUser))
  add(query_598152, "alt", newJString(alt))
  add(query_598152, "oauth_token", newJString(oauthToken))
  add(query_598152, "userIp", newJString(userIp))
  add(query_598152, "key", newJString(key))
  add(query_598152, "prettyPrint", newJBool(prettyPrint))
  result = call_598151.call(nil, query_598152, nil, nil, nil)

var adexchangesellerMetadataMetricsList* = Call_AdexchangesellerMetadataMetricsList_598140(
    name: "adexchangesellerMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdexchangesellerMetadataMetricsList_598141,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerMetadataMetricsList_598142,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerPreferreddealsList_598153 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerPreferreddealsList_598155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerPreferreddealsList_598154(path: JsonNode;
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
  var valid_598156 = query.getOrDefault("fields")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "fields", valid_598156
  var valid_598157 = query.getOrDefault("quotaUser")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "quotaUser", valid_598157
  var valid_598158 = query.getOrDefault("alt")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = newJString("json"))
  if valid_598158 != nil:
    section.add "alt", valid_598158
  var valid_598159 = query.getOrDefault("oauth_token")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "oauth_token", valid_598159
  var valid_598160 = query.getOrDefault("userIp")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "userIp", valid_598160
  var valid_598161 = query.getOrDefault("key")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "key", valid_598161
  var valid_598162 = query.getOrDefault("prettyPrint")
  valid_598162 = validateParameter(valid_598162, JBool, required = false,
                                 default = newJBool(true))
  if valid_598162 != nil:
    section.add "prettyPrint", valid_598162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598163: Call_AdexchangesellerPreferreddealsList_598153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  let valid = call_598163.validator(path, query, header, formData, body)
  let scheme = call_598163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598163.url(scheme.get, call_598163.host, call_598163.base,
                         call_598163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598163, url, valid)

proc call*(call_598164: Call_AdexchangesellerPreferreddealsList_598153;
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
  var query_598165 = newJObject()
  add(query_598165, "fields", newJString(fields))
  add(query_598165, "quotaUser", newJString(quotaUser))
  add(query_598165, "alt", newJString(alt))
  add(query_598165, "oauth_token", newJString(oauthToken))
  add(query_598165, "userIp", newJString(userIp))
  add(query_598165, "key", newJString(key))
  add(query_598165, "prettyPrint", newJBool(prettyPrint))
  result = call_598164.call(nil, query_598165, nil, nil, nil)

var adexchangesellerPreferreddealsList* = Call_AdexchangesellerPreferreddealsList_598153(
    name: "adexchangesellerPreferreddealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/preferreddeals",
    validator: validate_AdexchangesellerPreferreddealsList_598154,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerPreferreddealsList_598155,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerPreferreddealsGet_598166 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerPreferreddealsGet_598168(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/preferreddeals/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerPreferreddealsGet_598167(path: JsonNode;
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
  var valid_598169 = path.getOrDefault("dealId")
  valid_598169 = validateParameter(valid_598169, JString, required = true,
                                 default = nil)
  if valid_598169 != nil:
    section.add "dealId", valid_598169
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
  var valid_598170 = query.getOrDefault("fields")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "fields", valid_598170
  var valid_598171 = query.getOrDefault("quotaUser")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "quotaUser", valid_598171
  var valid_598172 = query.getOrDefault("alt")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = newJString("json"))
  if valid_598172 != nil:
    section.add "alt", valid_598172
  var valid_598173 = query.getOrDefault("oauth_token")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "oauth_token", valid_598173
  var valid_598174 = query.getOrDefault("userIp")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "userIp", valid_598174
  var valid_598175 = query.getOrDefault("key")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "key", valid_598175
  var valid_598176 = query.getOrDefault("prettyPrint")
  valid_598176 = validateParameter(valid_598176, JBool, required = false,
                                 default = newJBool(true))
  if valid_598176 != nil:
    section.add "prettyPrint", valid_598176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598177: Call_AdexchangesellerPreferreddealsGet_598166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  let valid = call_598177.validator(path, query, header, formData, body)
  let scheme = call_598177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598177.url(scheme.get, call_598177.host, call_598177.base,
                         call_598177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598177, url, valid)

proc call*(call_598178: Call_AdexchangesellerPreferreddealsGet_598166;
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
  var path_598179 = newJObject()
  var query_598180 = newJObject()
  add(query_598180, "fields", newJString(fields))
  add(query_598180, "quotaUser", newJString(quotaUser))
  add(query_598180, "alt", newJString(alt))
  add(query_598180, "oauth_token", newJString(oauthToken))
  add(query_598180, "userIp", newJString(userIp))
  add(query_598180, "key", newJString(key))
  add(query_598180, "prettyPrint", newJBool(prettyPrint))
  add(path_598179, "dealId", newJString(dealId))
  result = call_598178.call(path_598179, query_598180, nil, nil, nil)

var adexchangesellerPreferreddealsGet* = Call_AdexchangesellerPreferreddealsGet_598166(
    name: "adexchangesellerPreferreddealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/preferreddeals/{dealId}",
    validator: validate_AdexchangesellerPreferreddealsGet_598167,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerPreferreddealsGet_598168,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsGenerate_598181 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerReportsGenerate_598183(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsGenerate_598182(path: JsonNode;
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
  var valid_598184 = query.getOrDefault("locale")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "locale", valid_598184
  var valid_598185 = query.getOrDefault("fields")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "fields", valid_598185
  var valid_598186 = query.getOrDefault("quotaUser")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "quotaUser", valid_598186
  var valid_598187 = query.getOrDefault("alt")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = newJString("json"))
  if valid_598187 != nil:
    section.add "alt", valid_598187
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598188 = query.getOrDefault("endDate")
  valid_598188 = validateParameter(valid_598188, JString, required = true,
                                 default = nil)
  if valid_598188 != nil:
    section.add "endDate", valid_598188
  var valid_598189 = query.getOrDefault("startDate")
  valid_598189 = validateParameter(valid_598189, JString, required = true,
                                 default = nil)
  if valid_598189 != nil:
    section.add "startDate", valid_598189
  var valid_598190 = query.getOrDefault("sort")
  valid_598190 = validateParameter(valid_598190, JArray, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "sort", valid_598190
  var valid_598191 = query.getOrDefault("oauth_token")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "oauth_token", valid_598191
  var valid_598192 = query.getOrDefault("userIp")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "userIp", valid_598192
  var valid_598193 = query.getOrDefault("maxResults")
  valid_598193 = validateParameter(valid_598193, JInt, required = false, default = nil)
  if valid_598193 != nil:
    section.add "maxResults", valid_598193
  var valid_598194 = query.getOrDefault("key")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "key", valid_598194
  var valid_598195 = query.getOrDefault("metric")
  valid_598195 = validateParameter(valid_598195, JArray, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "metric", valid_598195
  var valid_598196 = query.getOrDefault("prettyPrint")
  valid_598196 = validateParameter(valid_598196, JBool, required = false,
                                 default = newJBool(true))
  if valid_598196 != nil:
    section.add "prettyPrint", valid_598196
  var valid_598197 = query.getOrDefault("dimension")
  valid_598197 = validateParameter(valid_598197, JArray, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "dimension", valid_598197
  var valid_598198 = query.getOrDefault("filter")
  valid_598198 = validateParameter(valid_598198, JArray, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "filter", valid_598198
  var valid_598199 = query.getOrDefault("startIndex")
  valid_598199 = validateParameter(valid_598199, JInt, required = false, default = nil)
  if valid_598199 != nil:
    section.add "startIndex", valid_598199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598200: Call_AdexchangesellerReportsGenerate_598181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598200.validator(path, query, header, formData, body)
  let scheme = call_598200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598200.url(scheme.get, call_598200.host, call_598200.base,
                         call_598200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598200, url, valid)

proc call*(call_598201: Call_AdexchangesellerReportsGenerate_598181;
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
  var query_598202 = newJObject()
  add(query_598202, "locale", newJString(locale))
  add(query_598202, "fields", newJString(fields))
  add(query_598202, "quotaUser", newJString(quotaUser))
  add(query_598202, "alt", newJString(alt))
  add(query_598202, "endDate", newJString(endDate))
  add(query_598202, "startDate", newJString(startDate))
  if sort != nil:
    query_598202.add "sort", sort
  add(query_598202, "oauth_token", newJString(oauthToken))
  add(query_598202, "userIp", newJString(userIp))
  add(query_598202, "maxResults", newJInt(maxResults))
  add(query_598202, "key", newJString(key))
  if metric != nil:
    query_598202.add "metric", metric
  add(query_598202, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598202.add "dimension", dimension
  if filter != nil:
    query_598202.add "filter", filter
  add(query_598202, "startIndex", newJInt(startIndex))
  result = call_598201.call(nil, query_598202, nil, nil, nil)

var adexchangesellerReportsGenerate* = Call_AdexchangesellerReportsGenerate_598181(
    name: "adexchangesellerReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdexchangesellerReportsGenerate_598182,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsGenerate_598183,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedList_598203 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerReportsSavedList_598205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsSavedList_598204(path: JsonNode;
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
  var valid_598206 = query.getOrDefault("fields")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "fields", valid_598206
  var valid_598207 = query.getOrDefault("pageToken")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "pageToken", valid_598207
  var valid_598208 = query.getOrDefault("quotaUser")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "quotaUser", valid_598208
  var valid_598209 = query.getOrDefault("alt")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = newJString("json"))
  if valid_598209 != nil:
    section.add "alt", valid_598209
  var valid_598210 = query.getOrDefault("oauth_token")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "oauth_token", valid_598210
  var valid_598211 = query.getOrDefault("userIp")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "userIp", valid_598211
  var valid_598212 = query.getOrDefault("maxResults")
  valid_598212 = validateParameter(valid_598212, JInt, required = false, default = nil)
  if valid_598212 != nil:
    section.add "maxResults", valid_598212
  var valid_598213 = query.getOrDefault("key")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "key", valid_598213
  var valid_598214 = query.getOrDefault("prettyPrint")
  valid_598214 = validateParameter(valid_598214, JBool, required = false,
                                 default = newJBool(true))
  if valid_598214 != nil:
    section.add "prettyPrint", valid_598214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598215: Call_AdexchangesellerReportsSavedList_598203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_598215.validator(path, query, header, formData, body)
  let scheme = call_598215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598215.url(scheme.get, call_598215.host, call_598215.base,
                         call_598215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598215, url, valid)

proc call*(call_598216: Call_AdexchangesellerReportsSavedList_598203;
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
  var query_598217 = newJObject()
  add(query_598217, "fields", newJString(fields))
  add(query_598217, "pageToken", newJString(pageToken))
  add(query_598217, "quotaUser", newJString(quotaUser))
  add(query_598217, "alt", newJString(alt))
  add(query_598217, "oauth_token", newJString(oauthToken))
  add(query_598217, "userIp", newJString(userIp))
  add(query_598217, "maxResults", newJInt(maxResults))
  add(query_598217, "key", newJString(key))
  add(query_598217, "prettyPrint", newJBool(prettyPrint))
  result = call_598216.call(nil, query_598217, nil, nil, nil)

var adexchangesellerReportsSavedList* = Call_AdexchangesellerReportsSavedList_598203(
    name: "adexchangesellerReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdexchangesellerReportsSavedList_598204,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsSavedList_598205,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedGenerate_598218 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerReportsSavedGenerate_598220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerReportsSavedGenerate_598219(path: JsonNode;
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
  var valid_598221 = path.getOrDefault("savedReportId")
  valid_598221 = validateParameter(valid_598221, JString, required = true,
                                 default = nil)
  if valid_598221 != nil:
    section.add "savedReportId", valid_598221
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
  var valid_598222 = query.getOrDefault("locale")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "locale", valid_598222
  var valid_598223 = query.getOrDefault("fields")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "fields", valid_598223
  var valid_598224 = query.getOrDefault("quotaUser")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "quotaUser", valid_598224
  var valid_598225 = query.getOrDefault("alt")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = newJString("json"))
  if valid_598225 != nil:
    section.add "alt", valid_598225
  var valid_598226 = query.getOrDefault("oauth_token")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "oauth_token", valid_598226
  var valid_598227 = query.getOrDefault("userIp")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "userIp", valid_598227
  var valid_598228 = query.getOrDefault("maxResults")
  valid_598228 = validateParameter(valid_598228, JInt, required = false, default = nil)
  if valid_598228 != nil:
    section.add "maxResults", valid_598228
  var valid_598229 = query.getOrDefault("key")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "key", valid_598229
  var valid_598230 = query.getOrDefault("prettyPrint")
  valid_598230 = validateParameter(valid_598230, JBool, required = false,
                                 default = newJBool(true))
  if valid_598230 != nil:
    section.add "prettyPrint", valid_598230
  var valid_598231 = query.getOrDefault("startIndex")
  valid_598231 = validateParameter(valid_598231, JInt, required = false, default = nil)
  if valid_598231 != nil:
    section.add "startIndex", valid_598231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598232: Call_AdexchangesellerReportsSavedGenerate_598218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598232.validator(path, query, header, formData, body)
  let scheme = call_598232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598232.url(scheme.get, call_598232.host, call_598232.base,
                         call_598232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598232, url, valid)

proc call*(call_598233: Call_AdexchangesellerReportsSavedGenerate_598218;
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
  var path_598234 = newJObject()
  var query_598235 = newJObject()
  add(query_598235, "locale", newJString(locale))
  add(query_598235, "fields", newJString(fields))
  add(query_598235, "quotaUser", newJString(quotaUser))
  add(query_598235, "alt", newJString(alt))
  add(query_598235, "oauth_token", newJString(oauthToken))
  add(query_598235, "userIp", newJString(userIp))
  add(query_598235, "maxResults", newJInt(maxResults))
  add(path_598234, "savedReportId", newJString(savedReportId))
  add(query_598235, "key", newJString(key))
  add(query_598235, "prettyPrint", newJBool(prettyPrint))
  add(query_598235, "startIndex", newJInt(startIndex))
  result = call_598233.call(path_598234, query_598235, nil, nil, nil)

var adexchangesellerReportsSavedGenerate* = Call_AdexchangesellerReportsSavedGenerate_598218(
    name: "adexchangesellerReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdexchangesellerReportsSavedGenerate_598219,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsSavedGenerate_598220,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
