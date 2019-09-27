
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Ad Exchange Seller
## version: v2.0
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
  Call_AdexchangesellerAccountsList_597693 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsList_597695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdexchangesellerAccountsList_597694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all accounts available to this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of accounts to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("pageToken")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "pageToken", valid_597808
  var valid_597809 = query.getOrDefault("quotaUser")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "quotaUser", valid_597809
  var valid_597823 = query.getOrDefault("alt")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = newJString("json"))
  if valid_597823 != nil:
    section.add "alt", valid_597823
  var valid_597824 = query.getOrDefault("oauth_token")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "oauth_token", valid_597824
  var valid_597825 = query.getOrDefault("userIp")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "userIp", valid_597825
  var valid_597826 = query.getOrDefault("maxResults")
  valid_597826 = validateParameter(valid_597826, JInt, required = false, default = nil)
  if valid_597826 != nil:
    section.add "maxResults", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("prettyPrint")
  valid_597828 = validateParameter(valid_597828, JBool, required = false,
                                 default = newJBool(true))
  if valid_597828 != nil:
    section.add "prettyPrint", valid_597828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597851: Call_AdexchangesellerAccountsList_597693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this Ad Exchange account.
  ## 
  let valid = call_597851.validator(path, query, header, formData, body)
  let scheme = call_597851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597851.url(scheme.get, call_597851.host, call_597851.base,
                         call_597851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597851, url, valid)

proc call*(call_597922: Call_AdexchangesellerAccountsList_597693;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsList
  ## List all accounts available to this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_597923 = newJObject()
  add(query_597923, "fields", newJString(fields))
  add(query_597923, "pageToken", newJString(pageToken))
  add(query_597923, "quotaUser", newJString(quotaUser))
  add(query_597923, "alt", newJString(alt))
  add(query_597923, "oauth_token", newJString(oauthToken))
  add(query_597923, "userIp", newJString(userIp))
  add(query_597923, "maxResults", newJInt(maxResults))
  add(query_597923, "key", newJString(key))
  add(query_597923, "prettyPrint", newJBool(prettyPrint))
  result = call_597922.call(nil, query_597923, nil, nil, nil)

var adexchangesellerAccountsList* = Call_AdexchangesellerAccountsList_597693(
    name: "adexchangesellerAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdexchangesellerAccountsList_597694,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsList_597695,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsGet_597963 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsGet_597965(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAccountsGet_597964(path: JsonNode; query: JsonNode;
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
  var valid_597980 = path.getOrDefault("accountId")
  valid_597980 = validateParameter(valid_597980, JString, required = true,
                                 default = nil)
  if valid_597980 != nil:
    section.add "accountId", valid_597980
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
  var valid_597981 = query.getOrDefault("fields")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "fields", valid_597981
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
  var valid_597986 = query.getOrDefault("key")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "key", valid_597986
  var valid_597987 = query.getOrDefault("prettyPrint")
  valid_597987 = validateParameter(valid_597987, JBool, required = false,
                                 default = newJBool(true))
  if valid_597987 != nil:
    section.add "prettyPrint", valid_597987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597988: Call_AdexchangesellerAccountsGet_597963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange account.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_AdexchangesellerAccountsGet_597963; accountId: string;
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
  var path_597990 = newJObject()
  var query_597991 = newJObject()
  add(query_597991, "fields", newJString(fields))
  add(query_597991, "quotaUser", newJString(quotaUser))
  add(query_597991, "alt", newJString(alt))
  add(query_597991, "oauth_token", newJString(oauthToken))
  add(path_597990, "accountId", newJString(accountId))
  add(query_597991, "userIp", newJString(userIp))
  add(query_597991, "key", newJString(key))
  add(query_597991, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(path_597990, query_597991, nil, nil, nil)

var adexchangesellerAccountsGet* = Call_AdexchangesellerAccountsGet_597963(
    name: "adexchangesellerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdexchangesellerAccountsGet_597964,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsGet_597965,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsAdclientsList_597992 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsAdclientsList_597994(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsAdclientsList_597993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_597995 = path.getOrDefault("accountId")
  valid_597995 = validateParameter(valid_597995, JString, required = true,
                                 default = nil)
  if valid_597995 != nil:
    section.add "accountId", valid_597995
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
  var valid_598000 = query.getOrDefault("oauth_token")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "oauth_token", valid_598000
  var valid_598001 = query.getOrDefault("userIp")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "userIp", valid_598001
  var valid_598002 = query.getOrDefault("maxResults")
  valid_598002 = validateParameter(valid_598002, JInt, required = false, default = nil)
  if valid_598002 != nil:
    section.add "maxResults", valid_598002
  var valid_598003 = query.getOrDefault("key")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "key", valid_598003
  var valid_598004 = query.getOrDefault("prettyPrint")
  valid_598004 = validateParameter(valid_598004, JBool, required = false,
                                 default = newJBool(true))
  if valid_598004 != nil:
    section.add "prettyPrint", valid_598004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598005: Call_AdexchangesellerAccountsAdclientsList_597992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_598005.validator(path, query, header, formData, body)
  let scheme = call_598005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598005.url(scheme.get, call_598005.host, call_598005.base,
                         call_598005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598005, url, valid)

proc call*(call_598006: Call_AdexchangesellerAccountsAdclientsList_597992;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsAdclientsList
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598007 = newJObject()
  var query_598008 = newJObject()
  add(query_598008, "fields", newJString(fields))
  add(query_598008, "pageToken", newJString(pageToken))
  add(query_598008, "quotaUser", newJString(quotaUser))
  add(query_598008, "alt", newJString(alt))
  add(query_598008, "oauth_token", newJString(oauthToken))
  add(path_598007, "accountId", newJString(accountId))
  add(query_598008, "userIp", newJString(userIp))
  add(query_598008, "maxResults", newJInt(maxResults))
  add(query_598008, "key", newJString(key))
  add(query_598008, "prettyPrint", newJBool(prettyPrint))
  result = call_598006.call(path_598007, query_598008, nil, nil, nil)

var adexchangesellerAccountsAdclientsList* = Call_AdexchangesellerAccountsAdclientsList_597992(
    name: "adexchangesellerAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdexchangesellerAccountsAdclientsList_597993,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsAdclientsList_597994, schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsCustomchannelsList_598009 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsCustomchannelsList_598011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsCustomchannelsList_598010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598012 = path.getOrDefault("accountId")
  valid_598012 = validateParameter(valid_598012, JString, required = true,
                                 default = nil)
  if valid_598012 != nil:
    section.add "accountId", valid_598012
  var valid_598013 = path.getOrDefault("adClientId")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "adClientId", valid_598013
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
  var valid_598014 = query.getOrDefault("fields")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "fields", valid_598014
  var valid_598015 = query.getOrDefault("pageToken")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "pageToken", valid_598015
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
  var valid_598020 = query.getOrDefault("maxResults")
  valid_598020 = validateParameter(valid_598020, JInt, required = false, default = nil)
  if valid_598020 != nil:
    section.add "maxResults", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("prettyPrint")
  valid_598022 = validateParameter(valid_598022, JBool, required = false,
                                 default = newJBool(true))
  if valid_598022 != nil:
    section.add "prettyPrint", valid_598022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598023: Call_AdexchangesellerAccountsCustomchannelsList_598009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598023.validator(path, query, header, formData, body)
  let scheme = call_598023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598023.url(scheme.get, call_598023.host, call_598023.base,
                         call_598023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598023, url, valid)

proc call*(call_598024: Call_AdexchangesellerAccountsCustomchannelsList_598009;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsCustomchannelsList
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_598025 = newJObject()
  var query_598026 = newJObject()
  add(query_598026, "fields", newJString(fields))
  add(query_598026, "pageToken", newJString(pageToken))
  add(query_598026, "quotaUser", newJString(quotaUser))
  add(query_598026, "alt", newJString(alt))
  add(query_598026, "oauth_token", newJString(oauthToken))
  add(path_598025, "accountId", newJString(accountId))
  add(query_598026, "userIp", newJString(userIp))
  add(query_598026, "maxResults", newJInt(maxResults))
  add(query_598026, "key", newJString(key))
  add(path_598025, "adClientId", newJString(adClientId))
  add(query_598026, "prettyPrint", newJBool(prettyPrint))
  result = call_598024.call(path_598025, query_598026, nil, nil, nil)

var adexchangesellerAccountsCustomchannelsList* = Call_AdexchangesellerAccountsCustomchannelsList_598009(
    name: "adexchangesellerAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerAccountsCustomchannelsList_598010,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsCustomchannelsList_598011,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsCustomchannelsGet_598027 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsCustomchannelsGet_598029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "customChannelId" in path, "`customChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/customchannels/"),
               (kind: VariableSegment, value: "customChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsCustomchannelsGet_598028(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598030 = path.getOrDefault("accountId")
  valid_598030 = validateParameter(valid_598030, JString, required = true,
                                 default = nil)
  if valid_598030 != nil:
    section.add "accountId", valid_598030
  var valid_598031 = path.getOrDefault("customChannelId")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "customChannelId", valid_598031
  var valid_598032 = path.getOrDefault("adClientId")
  valid_598032 = validateParameter(valid_598032, JString, required = true,
                                 default = nil)
  if valid_598032 != nil:
    section.add "adClientId", valid_598032
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
  var valid_598033 = query.getOrDefault("fields")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "fields", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("oauth_token")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "oauth_token", valid_598036
  var valid_598037 = query.getOrDefault("userIp")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "userIp", valid_598037
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

proc call*(call_598040: Call_AdexchangesellerAccountsCustomchannelsGet_598027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_598040.validator(path, query, header, formData, body)
  let scheme = call_598040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598040.url(scheme.get, call_598040.host, call_598040.base,
                         call_598040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598040, url, valid)

proc call*(call_598041: Call_AdexchangesellerAccountsCustomchannelsGet_598027;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_598042 = newJObject()
  var query_598043 = newJObject()
  add(query_598043, "fields", newJString(fields))
  add(query_598043, "quotaUser", newJString(quotaUser))
  add(query_598043, "alt", newJString(alt))
  add(query_598043, "oauth_token", newJString(oauthToken))
  add(path_598042, "accountId", newJString(accountId))
  add(path_598042, "customChannelId", newJString(customChannelId))
  add(query_598043, "userIp", newJString(userIp))
  add(query_598043, "key", newJString(key))
  add(path_598042, "adClientId", newJString(adClientId))
  add(query_598043, "prettyPrint", newJBool(prettyPrint))
  result = call_598041.call(path_598042, query_598043, nil, nil, nil)

var adexchangesellerAccountsCustomchannelsGet* = Call_AdexchangesellerAccountsCustomchannelsGet_598027(
    name: "adexchangesellerAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerAccountsCustomchannelsGet_598028,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsCustomchannelsGet_598029,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsUrlchannelsList_598044 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsUrlchannelsList_598046(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsUrlchannelsList_598045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598047 = path.getOrDefault("accountId")
  valid_598047 = validateParameter(valid_598047, JString, required = true,
                                 default = nil)
  if valid_598047 != nil:
    section.add "accountId", valid_598047
  var valid_598048 = path.getOrDefault("adClientId")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "adClientId", valid_598048
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
  var valid_598049 = query.getOrDefault("fields")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "fields", valid_598049
  var valid_598050 = query.getOrDefault("pageToken")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "pageToken", valid_598050
  var valid_598051 = query.getOrDefault("quotaUser")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "quotaUser", valid_598051
  var valid_598052 = query.getOrDefault("alt")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = newJString("json"))
  if valid_598052 != nil:
    section.add "alt", valid_598052
  var valid_598053 = query.getOrDefault("oauth_token")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "oauth_token", valid_598053
  var valid_598054 = query.getOrDefault("userIp")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "userIp", valid_598054
  var valid_598055 = query.getOrDefault("maxResults")
  valid_598055 = validateParameter(valid_598055, JInt, required = false, default = nil)
  if valid_598055 != nil:
    section.add "maxResults", valid_598055
  var valid_598056 = query.getOrDefault("key")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "key", valid_598056
  var valid_598057 = query.getOrDefault("prettyPrint")
  valid_598057 = validateParameter(valid_598057, JBool, required = false,
                                 default = newJBool(true))
  if valid_598057 != nil:
    section.add "prettyPrint", valid_598057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598058: Call_AdexchangesellerAccountsUrlchannelsList_598044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_598058.validator(path, query, header, formData, body)
  let scheme = call_598058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598058.url(scheme.get, call_598058.host, call_598058.base,
                         call_598058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598058, url, valid)

proc call*(call_598059: Call_AdexchangesellerAccountsUrlchannelsList_598044;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsUrlchannelsList
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_598060 = newJObject()
  var query_598061 = newJObject()
  add(query_598061, "fields", newJString(fields))
  add(query_598061, "pageToken", newJString(pageToken))
  add(query_598061, "quotaUser", newJString(quotaUser))
  add(query_598061, "alt", newJString(alt))
  add(query_598061, "oauth_token", newJString(oauthToken))
  add(path_598060, "accountId", newJString(accountId))
  add(query_598061, "userIp", newJString(userIp))
  add(query_598061, "maxResults", newJInt(maxResults))
  add(query_598061, "key", newJString(key))
  add(path_598060, "adClientId", newJString(adClientId))
  add(query_598061, "prettyPrint", newJBool(prettyPrint))
  result = call_598059.call(path_598060, query_598061, nil, nil, nil)

var adexchangesellerAccountsUrlchannelsList* = Call_AdexchangesellerAccountsUrlchannelsList_598044(
    name: "adexchangesellerAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerAccountsUrlchannelsList_598045,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsUrlchannelsList_598046,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsAlertsList_598062 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsAlertsList_598064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/alerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsAlertsList_598063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598065 = path.getOrDefault("accountId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "accountId", valid_598065
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
  var valid_598066 = query.getOrDefault("locale")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = nil)
  if valid_598066 != nil:
    section.add "locale", valid_598066
  var valid_598067 = query.getOrDefault("fields")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "fields", valid_598067
  var valid_598068 = query.getOrDefault("quotaUser")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "quotaUser", valid_598068
  var valid_598069 = query.getOrDefault("alt")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = newJString("json"))
  if valid_598069 != nil:
    section.add "alt", valid_598069
  var valid_598070 = query.getOrDefault("oauth_token")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "oauth_token", valid_598070
  var valid_598071 = query.getOrDefault("userIp")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "userIp", valid_598071
  var valid_598072 = query.getOrDefault("key")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "key", valid_598072
  var valid_598073 = query.getOrDefault("prettyPrint")
  valid_598073 = validateParameter(valid_598073, JBool, required = false,
                                 default = newJBool(true))
  if valid_598073 != nil:
    section.add "prettyPrint", valid_598073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598074: Call_AdexchangesellerAccountsAlertsList_598062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the alerts for this Ad Exchange account.
  ## 
  let valid = call_598074.validator(path, query, header, formData, body)
  let scheme = call_598074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598074.url(scheme.get, call_598074.host, call_598074.base,
                         call_598074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598074, url, valid)

proc call*(call_598075: Call_AdexchangesellerAccountsAlertsList_598062;
          accountId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsAlertsList
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
  ##   accountId: string (required)
  ##            : Account owning the alerts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598076 = newJObject()
  var query_598077 = newJObject()
  add(query_598077, "locale", newJString(locale))
  add(query_598077, "fields", newJString(fields))
  add(query_598077, "quotaUser", newJString(quotaUser))
  add(query_598077, "alt", newJString(alt))
  add(query_598077, "oauth_token", newJString(oauthToken))
  add(path_598076, "accountId", newJString(accountId))
  add(query_598077, "userIp", newJString(userIp))
  add(query_598077, "key", newJString(key))
  add(query_598077, "prettyPrint", newJBool(prettyPrint))
  result = call_598075.call(path_598076, query_598077, nil, nil, nil)

var adexchangesellerAccountsAlertsList* = Call_AdexchangesellerAccountsAlertsList_598062(
    name: "adexchangesellerAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdexchangesellerAccountsAlertsList_598063,
    base: "/adexchangeseller/v2.0", url: url_AdexchangesellerAccountsAlertsList_598064,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsMetadataDimensionsList_598078 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsMetadataDimensionsList_598080(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/metadata/dimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsMetadataDimensionsList_598079(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account with visibility to the dimensions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598081 = path.getOrDefault("accountId")
  valid_598081 = validateParameter(valid_598081, JString, required = true,
                                 default = nil)
  if valid_598081 != nil:
    section.add "accountId", valid_598081
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
  var valid_598082 = query.getOrDefault("fields")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "fields", valid_598082
  var valid_598083 = query.getOrDefault("quotaUser")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "quotaUser", valid_598083
  var valid_598084 = query.getOrDefault("alt")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("json"))
  if valid_598084 != nil:
    section.add "alt", valid_598084
  var valid_598085 = query.getOrDefault("oauth_token")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "oauth_token", valid_598085
  var valid_598086 = query.getOrDefault("userIp")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "userIp", valid_598086
  var valid_598087 = query.getOrDefault("key")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "key", valid_598087
  var valid_598088 = query.getOrDefault("prettyPrint")
  valid_598088 = validateParameter(valid_598088, JBool, required = false,
                                 default = newJBool(true))
  if valid_598088 != nil:
    section.add "prettyPrint", valid_598088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598089: Call_AdexchangesellerAccountsMetadataDimensionsList_598078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  let valid = call_598089.validator(path, query, header, formData, body)
  let scheme = call_598089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598089.url(scheme.get, call_598089.host, call_598089.base,
                         call_598089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598089, url, valid)

proc call*(call_598090: Call_AdexchangesellerAccountsMetadataDimensionsList_598078;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdExchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account with visibility to the dimensions.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598091 = newJObject()
  var query_598092 = newJObject()
  add(query_598092, "fields", newJString(fields))
  add(query_598092, "quotaUser", newJString(quotaUser))
  add(query_598092, "alt", newJString(alt))
  add(query_598092, "oauth_token", newJString(oauthToken))
  add(path_598091, "accountId", newJString(accountId))
  add(query_598092, "userIp", newJString(userIp))
  add(query_598092, "key", newJString(key))
  add(query_598092, "prettyPrint", newJBool(prettyPrint))
  result = call_598090.call(path_598091, query_598092, nil, nil, nil)

var adexchangesellerAccountsMetadataDimensionsList* = Call_AdexchangesellerAccountsMetadataDimensionsList_598078(
    name: "adexchangesellerAccountsMetadataDimensionsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/metadata/dimensions",
    validator: validate_AdexchangesellerAccountsMetadataDimensionsList_598079,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsMetadataDimensionsList_598080,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsMetadataMetricsList_598093 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsMetadataMetricsList_598095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/metadata/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsMetadataMetricsList_598094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account with visibility to the metrics.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598096 = path.getOrDefault("accountId")
  valid_598096 = validateParameter(valid_598096, JString, required = true,
                                 default = nil)
  if valid_598096 != nil:
    section.add "accountId", valid_598096
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
  var valid_598097 = query.getOrDefault("fields")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "fields", valid_598097
  var valid_598098 = query.getOrDefault("quotaUser")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "quotaUser", valid_598098
  var valid_598099 = query.getOrDefault("alt")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = newJString("json"))
  if valid_598099 != nil:
    section.add "alt", valid_598099
  var valid_598100 = query.getOrDefault("oauth_token")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "oauth_token", valid_598100
  var valid_598101 = query.getOrDefault("userIp")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "userIp", valid_598101
  var valid_598102 = query.getOrDefault("key")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "key", valid_598102
  var valid_598103 = query.getOrDefault("prettyPrint")
  valid_598103 = validateParameter(valid_598103, JBool, required = false,
                                 default = newJBool(true))
  if valid_598103 != nil:
    section.add "prettyPrint", valid_598103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598104: Call_AdexchangesellerAccountsMetadataMetricsList_598093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  let valid = call_598104.validator(path, query, header, formData, body)
  let scheme = call_598104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598104.url(scheme.get, call_598104.host, call_598104.base,
                         call_598104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598104, url, valid)

proc call*(call_598105: Call_AdexchangesellerAccountsMetadataMetricsList_598093;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsMetadataMetricsList
  ## List the metadata for the metrics available to this AdExchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account with visibility to the metrics.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598106 = newJObject()
  var query_598107 = newJObject()
  add(query_598107, "fields", newJString(fields))
  add(query_598107, "quotaUser", newJString(quotaUser))
  add(query_598107, "alt", newJString(alt))
  add(query_598107, "oauth_token", newJString(oauthToken))
  add(path_598106, "accountId", newJString(accountId))
  add(query_598107, "userIp", newJString(userIp))
  add(query_598107, "key", newJString(key))
  add(query_598107, "prettyPrint", newJBool(prettyPrint))
  result = call_598105.call(path_598106, query_598107, nil, nil, nil)

var adexchangesellerAccountsMetadataMetricsList* = Call_AdexchangesellerAccountsMetadataMetricsList_598093(
    name: "adexchangesellerAccountsMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/metadata/metrics",
    validator: validate_AdexchangesellerAccountsMetadataMetricsList_598094,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsMetadataMetricsList_598095,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsPreferreddealsList_598108 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsPreferreddealsList_598110(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/preferreddeals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsPreferreddealsList_598109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the deals.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598111 = path.getOrDefault("accountId")
  valid_598111 = validateParameter(valid_598111, JString, required = true,
                                 default = nil)
  if valid_598111 != nil:
    section.add "accountId", valid_598111
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
  var valid_598112 = query.getOrDefault("fields")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "fields", valid_598112
  var valid_598113 = query.getOrDefault("quotaUser")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = nil)
  if valid_598113 != nil:
    section.add "quotaUser", valid_598113
  var valid_598114 = query.getOrDefault("alt")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = newJString("json"))
  if valid_598114 != nil:
    section.add "alt", valid_598114
  var valid_598115 = query.getOrDefault("oauth_token")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "oauth_token", valid_598115
  var valid_598116 = query.getOrDefault("userIp")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "userIp", valid_598116
  var valid_598117 = query.getOrDefault("key")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "key", valid_598117
  var valid_598118 = query.getOrDefault("prettyPrint")
  valid_598118 = validateParameter(valid_598118, JBool, required = false,
                                 default = newJBool(true))
  if valid_598118 != nil:
    section.add "prettyPrint", valid_598118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598119: Call_AdexchangesellerAccountsPreferreddealsList_598108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  let valid = call_598119.validator(path, query, header, formData, body)
  let scheme = call_598119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598119.url(scheme.get, call_598119.host, call_598119.base,
                         call_598119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598119, url, valid)

proc call*(call_598120: Call_AdexchangesellerAccountsPreferreddealsList_598108;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsPreferreddealsList
  ## List the preferred deals for this Ad Exchange account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the deals.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598121 = newJObject()
  var query_598122 = newJObject()
  add(query_598122, "fields", newJString(fields))
  add(query_598122, "quotaUser", newJString(quotaUser))
  add(query_598122, "alt", newJString(alt))
  add(query_598122, "oauth_token", newJString(oauthToken))
  add(path_598121, "accountId", newJString(accountId))
  add(query_598122, "userIp", newJString(userIp))
  add(query_598122, "key", newJString(key))
  add(query_598122, "prettyPrint", newJBool(prettyPrint))
  result = call_598120.call(path_598121, query_598122, nil, nil, nil)

var adexchangesellerAccountsPreferreddealsList* = Call_AdexchangesellerAccountsPreferreddealsList_598108(
    name: "adexchangesellerAccountsPreferreddealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/preferreddeals",
    validator: validate_AdexchangesellerAccountsPreferreddealsList_598109,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsPreferreddealsList_598110,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsPreferreddealsGet_598123 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsPreferreddealsGet_598125(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "dealId" in path, "`dealId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/preferreddeals/"),
               (kind: VariableSegment, value: "dealId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsPreferreddealsGet_598124(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the deal.
  ##   dealId: JString (required)
  ##         : Preferred deal to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598126 = path.getOrDefault("accountId")
  valid_598126 = validateParameter(valid_598126, JString, required = true,
                                 default = nil)
  if valid_598126 != nil:
    section.add "accountId", valid_598126
  var valid_598127 = path.getOrDefault("dealId")
  valid_598127 = validateParameter(valid_598127, JString, required = true,
                                 default = nil)
  if valid_598127 != nil:
    section.add "dealId", valid_598127
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
  var valid_598128 = query.getOrDefault("fields")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "fields", valid_598128
  var valid_598129 = query.getOrDefault("quotaUser")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "quotaUser", valid_598129
  var valid_598130 = query.getOrDefault("alt")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = newJString("json"))
  if valid_598130 != nil:
    section.add "alt", valid_598130
  var valid_598131 = query.getOrDefault("oauth_token")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "oauth_token", valid_598131
  var valid_598132 = query.getOrDefault("userIp")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "userIp", valid_598132
  var valid_598133 = query.getOrDefault("key")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "key", valid_598133
  var valid_598134 = query.getOrDefault("prettyPrint")
  valid_598134 = validateParameter(valid_598134, JBool, required = false,
                                 default = newJBool(true))
  if valid_598134 != nil:
    section.add "prettyPrint", valid_598134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598135: Call_AdexchangesellerAccountsPreferreddealsGet_598123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  let valid = call_598135.validator(path, query, header, formData, body)
  let scheme = call_598135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598135.url(scheme.get, call_598135.host, call_598135.base,
                         call_598135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598135, url, valid)

proc call*(call_598136: Call_AdexchangesellerAccountsPreferreddealsGet_598123;
          accountId: string; dealId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsPreferreddealsGet
  ## Get information about the selected Ad Exchange Preferred Deal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account owning the deal.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   dealId: string (required)
  ##         : Preferred deal to get information about.
  var path_598137 = newJObject()
  var query_598138 = newJObject()
  add(query_598138, "fields", newJString(fields))
  add(query_598138, "quotaUser", newJString(quotaUser))
  add(query_598138, "alt", newJString(alt))
  add(query_598138, "oauth_token", newJString(oauthToken))
  add(path_598137, "accountId", newJString(accountId))
  add(query_598138, "userIp", newJString(userIp))
  add(query_598138, "key", newJString(key))
  add(query_598138, "prettyPrint", newJBool(prettyPrint))
  add(path_598137, "dealId", newJString(dealId))
  result = call_598136.call(path_598137, query_598138, nil, nil, nil)

var adexchangesellerAccountsPreferreddealsGet* = Call_AdexchangesellerAccountsPreferreddealsGet_598123(
    name: "adexchangesellerAccountsPreferreddealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/preferreddeals/{dealId}",
    validator: validate_AdexchangesellerAccountsPreferreddealsGet_598124,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsPreferreddealsGet_598125,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsGenerate_598139 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsReportsGenerate_598141(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsReportsGenerate_598140(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which owns the generated report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598142 = path.getOrDefault("accountId")
  valid_598142 = validateParameter(valid_598142, JString, required = true,
                                 default = nil)
  if valid_598142 != nil:
    section.add "accountId", valid_598142
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
  var valid_598143 = query.getOrDefault("locale")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "locale", valid_598143
  var valid_598144 = query.getOrDefault("fields")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "fields", valid_598144
  var valid_598145 = query.getOrDefault("quotaUser")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "quotaUser", valid_598145
  var valid_598146 = query.getOrDefault("alt")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = newJString("json"))
  if valid_598146 != nil:
    section.add "alt", valid_598146
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598147 = query.getOrDefault("endDate")
  valid_598147 = validateParameter(valid_598147, JString, required = true,
                                 default = nil)
  if valid_598147 != nil:
    section.add "endDate", valid_598147
  var valid_598148 = query.getOrDefault("startDate")
  valid_598148 = validateParameter(valid_598148, JString, required = true,
                                 default = nil)
  if valid_598148 != nil:
    section.add "startDate", valid_598148
  var valid_598149 = query.getOrDefault("sort")
  valid_598149 = validateParameter(valid_598149, JArray, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "sort", valid_598149
  var valid_598150 = query.getOrDefault("oauth_token")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "oauth_token", valid_598150
  var valid_598151 = query.getOrDefault("userIp")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "userIp", valid_598151
  var valid_598152 = query.getOrDefault("maxResults")
  valid_598152 = validateParameter(valid_598152, JInt, required = false, default = nil)
  if valid_598152 != nil:
    section.add "maxResults", valid_598152
  var valid_598153 = query.getOrDefault("key")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "key", valid_598153
  var valid_598154 = query.getOrDefault("metric")
  valid_598154 = validateParameter(valid_598154, JArray, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "metric", valid_598154
  var valid_598155 = query.getOrDefault("prettyPrint")
  valid_598155 = validateParameter(valid_598155, JBool, required = false,
                                 default = newJBool(true))
  if valid_598155 != nil:
    section.add "prettyPrint", valid_598155
  var valid_598156 = query.getOrDefault("dimension")
  valid_598156 = validateParameter(valid_598156, JArray, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "dimension", valid_598156
  var valid_598157 = query.getOrDefault("filter")
  valid_598157 = validateParameter(valid_598157, JArray, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "filter", valid_598157
  var valid_598158 = query.getOrDefault("startIndex")
  valid_598158 = validateParameter(valid_598158, JInt, required = false, default = nil)
  if valid_598158 != nil:
    section.add "startIndex", valid_598158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598159: Call_AdexchangesellerAccountsReportsGenerate_598139;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598159.validator(path, query, header, formData, body)
  let scheme = call_598159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598159.url(scheme.get, call_598159.host, call_598159.base,
                         call_598159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598159, url, valid)

proc call*(call_598160: Call_AdexchangesellerAccountsReportsGenerate_598139;
          endDate: string; startDate: string; accountId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sort: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; metric: JsonNode = nil;
          prettyPrint: bool = true; dimension: JsonNode = nil; filter: JsonNode = nil;
          startIndex: int = 0): Recallable =
  ## adexchangesellerAccountsReportsGenerate
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
  ##   accountId: string (required)
  ##            : Account which owns the generated report.
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
  var path_598161 = newJObject()
  var query_598162 = newJObject()
  add(query_598162, "locale", newJString(locale))
  add(query_598162, "fields", newJString(fields))
  add(query_598162, "quotaUser", newJString(quotaUser))
  add(query_598162, "alt", newJString(alt))
  add(query_598162, "endDate", newJString(endDate))
  add(query_598162, "startDate", newJString(startDate))
  if sort != nil:
    query_598162.add "sort", sort
  add(query_598162, "oauth_token", newJString(oauthToken))
  add(path_598161, "accountId", newJString(accountId))
  add(query_598162, "userIp", newJString(userIp))
  add(query_598162, "maxResults", newJInt(maxResults))
  add(query_598162, "key", newJString(key))
  if metric != nil:
    query_598162.add "metric", metric
  add(query_598162, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598162.add "dimension", dimension
  if filter != nil:
    query_598162.add "filter", filter
  add(query_598162, "startIndex", newJInt(startIndex))
  result = call_598160.call(path_598161, query_598162, nil, nil, nil)

var adexchangesellerAccountsReportsGenerate* = Call_AdexchangesellerAccountsReportsGenerate_598139(
    name: "adexchangesellerAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdexchangesellerAccountsReportsGenerate_598140,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsGenerate_598141,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsSavedList_598163 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsReportsSavedList_598165(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports/saved")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsReportsSavedList_598164(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the saved reports.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598166 = path.getOrDefault("accountId")
  valid_598166 = validateParameter(valid_598166, JString, required = true,
                                 default = nil)
  if valid_598166 != nil:
    section.add "accountId", valid_598166
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
  var valid_598167 = query.getOrDefault("fields")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "fields", valid_598167
  var valid_598168 = query.getOrDefault("pageToken")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "pageToken", valid_598168
  var valid_598169 = query.getOrDefault("quotaUser")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "quotaUser", valid_598169
  var valid_598170 = query.getOrDefault("alt")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = newJString("json"))
  if valid_598170 != nil:
    section.add "alt", valid_598170
  var valid_598171 = query.getOrDefault("oauth_token")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "oauth_token", valid_598171
  var valid_598172 = query.getOrDefault("userIp")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "userIp", valid_598172
  var valid_598173 = query.getOrDefault("maxResults")
  valid_598173 = validateParameter(valid_598173, JInt, required = false, default = nil)
  if valid_598173 != nil:
    section.add "maxResults", valid_598173
  var valid_598174 = query.getOrDefault("key")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "key", valid_598174
  var valid_598175 = query.getOrDefault("prettyPrint")
  valid_598175 = validateParameter(valid_598175, JBool, required = false,
                                 default = newJBool(true))
  if valid_598175 != nil:
    section.add "prettyPrint", valid_598175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598176: Call_AdexchangesellerAccountsReportsSavedList_598163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_598176.validator(path, query, header, formData, body)
  let scheme = call_598176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598176.url(scheme.get, call_598176.host, call_598176.base,
                         call_598176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598176, url, valid)

proc call*(call_598177: Call_AdexchangesellerAccountsReportsSavedList_598163;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adexchangesellerAccountsReportsSavedList
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
  ##   accountId: string (required)
  ##            : Account owning the saved reports.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598178 = newJObject()
  var query_598179 = newJObject()
  add(query_598179, "fields", newJString(fields))
  add(query_598179, "pageToken", newJString(pageToken))
  add(query_598179, "quotaUser", newJString(quotaUser))
  add(query_598179, "alt", newJString(alt))
  add(query_598179, "oauth_token", newJString(oauthToken))
  add(path_598178, "accountId", newJString(accountId))
  add(query_598179, "userIp", newJString(userIp))
  add(query_598179, "maxResults", newJInt(maxResults))
  add(query_598179, "key", newJString(key))
  add(query_598179, "prettyPrint", newJBool(prettyPrint))
  result = call_598177.call(path_598178, query_598179, nil, nil, nil)

var adexchangesellerAccountsReportsSavedList* = Call_AdexchangesellerAccountsReportsSavedList_598163(
    name: "adexchangesellerAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdexchangesellerAccountsReportsSavedList_598164,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsSavedList_598165,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAccountsReportsSavedGenerate_598180 = ref object of OpenApiRestCall_597424
proc url_AdexchangesellerAccountsReportsSavedGenerate_598182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "savedReportId" in path, "`savedReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "savedReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdexchangesellerAccountsReportsSavedGenerate_598181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account owning the saved report.
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_598183 = path.getOrDefault("accountId")
  valid_598183 = validateParameter(valid_598183, JString, required = true,
                                 default = nil)
  if valid_598183 != nil:
    section.add "accountId", valid_598183
  var valid_598184 = path.getOrDefault("savedReportId")
  valid_598184 = validateParameter(valid_598184, JString, required = true,
                                 default = nil)
  if valid_598184 != nil:
    section.add "savedReportId", valid_598184
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
  var valid_598185 = query.getOrDefault("locale")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "locale", valid_598185
  var valid_598186 = query.getOrDefault("fields")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "fields", valid_598186
  var valid_598187 = query.getOrDefault("quotaUser")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "quotaUser", valid_598187
  var valid_598188 = query.getOrDefault("alt")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = newJString("json"))
  if valid_598188 != nil:
    section.add "alt", valid_598188
  var valid_598189 = query.getOrDefault("oauth_token")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "oauth_token", valid_598189
  var valid_598190 = query.getOrDefault("userIp")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "userIp", valid_598190
  var valid_598191 = query.getOrDefault("maxResults")
  valid_598191 = validateParameter(valid_598191, JInt, required = false, default = nil)
  if valid_598191 != nil:
    section.add "maxResults", valid_598191
  var valid_598192 = query.getOrDefault("key")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "key", valid_598192
  var valid_598193 = query.getOrDefault("prettyPrint")
  valid_598193 = validateParameter(valid_598193, JBool, required = false,
                                 default = newJBool(true))
  if valid_598193 != nil:
    section.add "prettyPrint", valid_598193
  var valid_598194 = query.getOrDefault("startIndex")
  valid_598194 = validateParameter(valid_598194, JInt, required = false, default = nil)
  if valid_598194 != nil:
    section.add "startIndex", valid_598194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598195: Call_AdexchangesellerAccountsReportsSavedGenerate_598180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598195.validator(path, query, header, formData, body)
  let scheme = call_598195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598195.url(scheme.get, call_598195.host, call_598195.base,
                         call_598195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598195, url, valid)

proc call*(call_598196: Call_AdexchangesellerAccountsReportsSavedGenerate_598180;
          accountId: string; savedReportId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adexchangesellerAccountsReportsSavedGenerate
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
  ##   accountId: string (required)
  ##            : Account owning the saved report.
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
  var path_598197 = newJObject()
  var query_598198 = newJObject()
  add(query_598198, "locale", newJString(locale))
  add(query_598198, "fields", newJString(fields))
  add(query_598198, "quotaUser", newJString(quotaUser))
  add(query_598198, "alt", newJString(alt))
  add(query_598198, "oauth_token", newJString(oauthToken))
  add(path_598197, "accountId", newJString(accountId))
  add(query_598198, "userIp", newJString(userIp))
  add(query_598198, "maxResults", newJInt(maxResults))
  add(path_598197, "savedReportId", newJString(savedReportId))
  add(query_598198, "key", newJString(key))
  add(query_598198, "prettyPrint", newJBool(prettyPrint))
  add(query_598198, "startIndex", newJInt(startIndex))
  result = call_598196.call(path_598197, query_598198, nil, nil, nil)

var adexchangesellerAccountsReportsSavedGenerate* = Call_AdexchangesellerAccountsReportsSavedGenerate_598180(
    name: "adexchangesellerAccountsReportsSavedGenerate",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdexchangesellerAccountsReportsSavedGenerate_598181,
    base: "/adexchangeseller/v2.0",
    url: url_AdexchangesellerAccountsReportsSavedGenerate_598182,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
