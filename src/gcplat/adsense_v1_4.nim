
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: AdSense Management
## version: v1.4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses AdSense publishers' inventory and generates performance reports.
## 
## https://developers.google.com/adsense/management/
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
  gcpServiceName = "adsense"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsenseAccountsList_579693 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsList_579695(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAccountsList_579694(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all accounts available to this AdSense account.
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
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("alt")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("json"))
  if valid_579823 != nil:
    section.add "alt", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("userIp")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userIp", valid_579825
  var valid_579826 = query.getOrDefault("maxResults")
  valid_579826 = validateParameter(valid_579826, JInt, required = false, default = nil)
  if valid_579826 != nil:
    section.add "maxResults", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("prettyPrint")
  valid_579828 = validateParameter(valid_579828, JBool, required = false,
                                 default = newJBool(true))
  if valid_579828 != nil:
    section.add "prettyPrint", valid_579828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579851: Call_AdsenseAccountsList_579693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this AdSense account.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_AdsenseAccountsList_579693; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsList
  ## List all accounts available to this AdSense account.
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
  var query_579923 = newJObject()
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "pageToken", newJString(pageToken))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "maxResults", newJInt(maxResults))
  add(query_579923, "key", newJString(key))
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, nil)

var adsenseAccountsList* = Call_AdsenseAccountsList_579693(
    name: "adsenseAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsenseAccountsList_579694, base: "/adsense/v1.4",
    url: url_AdsenseAccountsList_579695, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsGet_579963 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsGet_579965(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsGet_579964(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get information about the selected AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579980 = path.getOrDefault("accountId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "accountId", valid_579980
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
  ##   tree: JBool
  ##       : Whether the tree of sub accounts should be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
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
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
  var valid_579987 = query.getOrDefault("tree")
  valid_579987 = validateParameter(valid_579987, JBool, required = false, default = nil)
  if valid_579987 != nil:
    section.add "tree", valid_579987
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

proc call*(call_579989: Call_AdsenseAccountsGet_579963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected AdSense account.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_AdsenseAccountsGet_579963; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          tree: bool = false; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsGet
  ## Get information about the selected AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   tree: bool
  ##       : Whether the tree of sub accounts should be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(path_579991, "accountId", newJString(accountId))
  add(query_579992, "userIp", newJString(userIp))
  add(query_579992, "key", newJString(key))
  add(query_579992, "tree", newJBool(tree))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  result = call_579990.call(path_579991, query_579992, nil, nil, nil)

var adsenseAccountsGet* = Call_AdsenseAccountsGet_579963(
    name: "adsenseAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsenseAccountsGet_579964, base: "/adsense/v1.4",
    url: url_AdsenseAccountsGet_579965, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsList_579993 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdclientsList_579995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsAdclientsList_579994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list ad clients.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579996 = path.getOrDefault("accountId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "accountId", valid_579996
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
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
  var valid_579998 = query.getOrDefault("pageToken")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "pageToken", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
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

proc call*(call_580006: Call_AdsenseAccountsAdclientsList_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in the specified account.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_AdsenseAccountsAdclientsList_579993;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdclientsList
  ## List all ad clients in the specified account.
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
  ##            : Account for which to list ad clients.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "pageToken", newJString(pageToken))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(path_580008, "accountId", newJString(accountId))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "maxResults", newJInt(maxResults))
  add(query_580009, "key", newJString(key))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, nil)

var adsenseAccountsAdclientsList* = Call_AdsenseAccountsAdclientsList_579993(
    name: "adsenseAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsenseAccountsAdclientsList_579994,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdclientsList_579995,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsGetAdCode_580010 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdclientsGetAdCode_580012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdclientsGetAdCode_580011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Auto ad code for a given ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client to get the code for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580013 = path.getOrDefault("accountId")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "accountId", valid_580013
  var valid_580014 = path.getOrDefault("adClientId")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "adClientId", valid_580014
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

proc call*(call_580022: Call_AdsenseAccountsAdclientsGetAdCode_580010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Auto ad code for a given ad client.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_AdsenseAccountsAdclientsGetAdCode_580010;
          accountId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdclientsGetAdCode
  ## Get Auto ad code for a given ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(path_580024, "accountId", newJString(accountId))
  add(query_580025, "userIp", newJString(userIp))
  add(query_580025, "key", newJString(key))
  add(path_580024, "adClientId", newJString(adClientId))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var adsenseAccountsAdclientsGetAdCode* = Call_AdsenseAccountsAdclientsGetAdCode_580010(
    name: "adsenseAccountsAdclientsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adcode",
    validator: validate_AdsenseAccountsAdclientsGetAdCode_580011,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdclientsGetAdCode_580012,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_580026 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsList_580028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsList_580027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580029 = path.getOrDefault("accountId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "accountId", valid_580029
  var valid_580030 = path.getOrDefault("adClientId")
  valid_580030 = validateParameter(valid_580030, JString, required = true,
                                 default = nil)
  if valid_580030 != nil:
    section.add "adClientId", valid_580030
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
  var valid_580035 = query.getOrDefault("includeInactive")
  valid_580035 = validateParameter(valid_580035, JBool, required = false, default = nil)
  if valid_580035 != nil:
    section.add "includeInactive", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("userIp")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "userIp", valid_580037
  var valid_580038 = query.getOrDefault("maxResults")
  valid_580038 = validateParameter(valid_580038, JInt, required = false, default = nil)
  if valid_580038 != nil:
    section.add "maxResults", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580041: Call_AdsenseAccountsAdunitsList_580026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_AdsenseAccountsAdunitsList_580026; accountId: string;
          adClientId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; includeInactive: bool = false;
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsList
  ## List all ad units in the specified ad client for the specified account.
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "pageToken", newJString(pageToken))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "includeInactive", newJBool(includeInactive))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(path_580043, "accountId", newJString(accountId))
  add(query_580044, "userIp", newJString(userIp))
  add(query_580044, "maxResults", newJInt(maxResults))
  add(query_580044, "key", newJString(key))
  add(path_580043, "adClientId", newJString(adClientId))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  result = call_580042.call(path_580043, query_580044, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_580026(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_580027, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAdunitsList_580028, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_580045 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsGet_580047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsGet_580046(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580048 = path.getOrDefault("accountId")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "accountId", valid_580048
  var valid_580049 = path.getOrDefault("adClientId")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "adClientId", valid_580049
  var valid_580050 = path.getOrDefault("adUnitId")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "adUnitId", valid_580050
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
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("alt")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("json"))
  if valid_580053 != nil:
    section.add "alt", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("userIp")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "userIp", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580058: Call_AdsenseAccountsAdunitsGet_580045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_AdsenseAccountsAdunitsGet_580045; accountId: string;
          adClientId: string; adUnitId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsGet
  ## Gets the specified ad unit in the specified ad client for the specified account.
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
  var path_580060 = newJObject()
  var query_580061 = newJObject()
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(path_580060, "accountId", newJString(accountId))
  add(query_580061, "userIp", newJString(userIp))
  add(query_580061, "key", newJString(key))
  add(path_580060, "adClientId", newJString(adClientId))
  add(path_580060, "adUnitId", newJString(adUnitId))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  result = call_580059.call(path_580060, query_580061, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_580045(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_580046, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAdunitsGet_580047, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_580062 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsGetAdCode_580064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsGetAdCode_580063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  ##   adClientId: JString (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get the code for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580065 = path.getOrDefault("accountId")
  valid_580065 = validateParameter(valid_580065, JString, required = true,
                                 default = nil)
  if valid_580065 != nil:
    section.add "accountId", valid_580065
  var valid_580066 = path.getOrDefault("adClientId")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "adClientId", valid_580066
  var valid_580067 = path.getOrDefault("adUnitId")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "adUnitId", valid_580067
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
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("alt")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = newJString("json"))
  if valid_580070 != nil:
    section.add "alt", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("userIp")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "userIp", valid_580072
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580075: Call_AdsenseAccountsAdunitsGetAdCode_580062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_AdsenseAccountsAdunitsGetAdCode_580062;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(path_580077, "accountId", newJString(accountId))
  add(query_580078, "userIp", newJString(userIp))
  add(query_580078, "key", newJString(key))
  add(path_580077, "adClientId", newJString(adClientId))
  add(path_580077, "adUnitId", newJString(adUnitId))
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  result = call_580076.call(path_580077, query_580078, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_580062(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_580063,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdunitsGetAdCode_580064,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_580079 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAdunitsCustomchannelsList_580081(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "adUnitId" in path, "`adUnitId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/adunits/"),
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsCustomchannelsList_580080(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit for which to list custom channels.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580082 = path.getOrDefault("accountId")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "accountId", valid_580082
  var valid_580083 = path.getOrDefault("adClientId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "adClientId", valid_580083
  var valid_580084 = path.getOrDefault("adUnitId")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "adUnitId", valid_580084
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
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("pageToken")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "pageToken", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("userIp")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "userIp", valid_580090
  var valid_580091 = query.getOrDefault("maxResults")
  valid_580091 = validateParameter(valid_580091, JInt, required = false, default = nil)
  if valid_580091 != nil:
    section.add "maxResults", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580094: Call_AdsenseAccountsAdunitsCustomchannelsList_580079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_580094.validator(path, query, header, formData, body)
  let scheme = call_580094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580094.url(scheme.get, call_580094.host, call_580094.base,
                         call_580094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580094, url, valid)

proc call*(call_580095: Call_AdsenseAccountsAdunitsCustomchannelsList_580079;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsCustomchannelsList
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_580096 = newJObject()
  var query_580097 = newJObject()
  add(query_580097, "fields", newJString(fields))
  add(query_580097, "pageToken", newJString(pageToken))
  add(query_580097, "quotaUser", newJString(quotaUser))
  add(query_580097, "alt", newJString(alt))
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(path_580096, "accountId", newJString(accountId))
  add(query_580097, "userIp", newJString(userIp))
  add(query_580097, "maxResults", newJInt(maxResults))
  add(query_580097, "key", newJString(key))
  add(path_580096, "adClientId", newJString(adClientId))
  add(path_580096, "adUnitId", newJString(adUnitId))
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  result = call_580095.call(path_580096, query_580097, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_580079(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_580080,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdunitsCustomchannelsList_580081,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_580098 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsCustomchannelsList_580100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsCustomchannelsList_580099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for the specified account.
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
  var valid_580101 = path.getOrDefault("accountId")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "accountId", valid_580101
  var valid_580102 = path.getOrDefault("adClientId")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "adClientId", valid_580102
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
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("pageToken")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "pageToken", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("alt")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("json"))
  if valid_580106 != nil:
    section.add "alt", valid_580106
  var valid_580107 = query.getOrDefault("oauth_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "oauth_token", valid_580107
  var valid_580108 = query.getOrDefault("userIp")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "userIp", valid_580108
  var valid_580109 = query.getOrDefault("maxResults")
  valid_580109 = validateParameter(valid_580109, JInt, required = false, default = nil)
  if valid_580109 != nil:
    section.add "maxResults", valid_580109
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580112: Call_AdsenseAccountsCustomchannelsList_580098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_AdsenseAccountsCustomchannelsList_580098;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsList
  ## List all custom channels in the specified ad client for the specified account.
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
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "pageToken", newJString(pageToken))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(path_580114, "accountId", newJString(accountId))
  add(query_580115, "userIp", newJString(userIp))
  add(query_580115, "maxResults", newJInt(maxResults))
  add(query_580115, "key", newJString(key))
  add(path_580114, "adClientId", newJString(adClientId))
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_580098(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_580099,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsList_580100,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_580116 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsCustomchannelsGet_580118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsCustomchannelsGet_580117(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client for the specified account.
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
  var valid_580119 = path.getOrDefault("accountId")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "accountId", valid_580119
  var valid_580120 = path.getOrDefault("customChannelId")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "customChannelId", valid_580120
  var valid_580121 = path.getOrDefault("adClientId")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "adClientId", valid_580121
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
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("alt")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("json"))
  if valid_580124 != nil:
    section.add "alt", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("userIp")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "userIp", valid_580126
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("prettyPrint")
  valid_580128 = validateParameter(valid_580128, JBool, required = false,
                                 default = newJBool(true))
  if valid_580128 != nil:
    section.add "prettyPrint", valid_580128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580129: Call_AdsenseAccountsCustomchannelsGet_580116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_580129.validator(path, query, header, formData, body)
  let scheme = call_580129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580129.url(scheme.get, call_580129.host, call_580129.base,
                         call_580129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580129, url, valid)

proc call*(call_580130: Call_AdsenseAccountsCustomchannelsGet_580116;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client for the specified account.
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
  var path_580131 = newJObject()
  var query_580132 = newJObject()
  add(query_580132, "fields", newJString(fields))
  add(query_580132, "quotaUser", newJString(quotaUser))
  add(query_580132, "alt", newJString(alt))
  add(query_580132, "oauth_token", newJString(oauthToken))
  add(path_580131, "accountId", newJString(accountId))
  add(path_580131, "customChannelId", newJString(customChannelId))
  add(query_580132, "userIp", newJString(userIp))
  add(query_580132, "key", newJString(key))
  add(path_580131, "adClientId", newJString(adClientId))
  add(query_580132, "prettyPrint", newJBool(prettyPrint))
  result = call_580130.call(path_580131, query_580132, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_580116(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_580117,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsGet_580118,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_580133 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsCustomchannelsAdunitsList_580135(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsCustomchannelsAdunitsList_580134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580136 = path.getOrDefault("accountId")
  valid_580136 = validateParameter(valid_580136, JString, required = true,
                                 default = nil)
  if valid_580136 != nil:
    section.add "accountId", valid_580136
  var valid_580137 = path.getOrDefault("customChannelId")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "customChannelId", valid_580137
  var valid_580138 = path.getOrDefault("adClientId")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "adClientId", valid_580138
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
  var valid_580139 = query.getOrDefault("fields")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "fields", valid_580139
  var valid_580140 = query.getOrDefault("pageToken")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "pageToken", valid_580140
  var valid_580141 = query.getOrDefault("quotaUser")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "quotaUser", valid_580141
  var valid_580142 = query.getOrDefault("alt")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("json"))
  if valid_580142 != nil:
    section.add "alt", valid_580142
  var valid_580143 = query.getOrDefault("includeInactive")
  valid_580143 = validateParameter(valid_580143, JBool, required = false, default = nil)
  if valid_580143 != nil:
    section.add "includeInactive", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("userIp")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "userIp", valid_580145
  var valid_580146 = query.getOrDefault("maxResults")
  valid_580146 = validateParameter(valid_580146, JInt, required = false, default = nil)
  if valid_580146 != nil:
    section.add "maxResults", valid_580146
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("prettyPrint")
  valid_580148 = validateParameter(valid_580148, JBool, required = false,
                                 default = newJBool(true))
  if valid_580148 != nil:
    section.add "prettyPrint", valid_580148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580149: Call_AdsenseAccountsCustomchannelsAdunitsList_580133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_AdsenseAccountsCustomchannelsAdunitsList_580133;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; includeInactive: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsAdunitsList
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
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
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
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "pageToken", newJString(pageToken))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "includeInactive", newJBool(includeInactive))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(path_580151, "accountId", newJString(accountId))
  add(path_580151, "customChannelId", newJString(customChannelId))
  add(query_580152, "userIp", newJString(userIp))
  add(query_580152, "maxResults", newJInt(maxResults))
  add(query_580152, "key", newJString(key))
  add(path_580151, "adClientId", newJString(adClientId))
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_580133(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_580134,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsAdunitsList_580135,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_580153 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsUrlchannelsList_580155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsUrlchannelsList_580154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for the specified account.
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
  var valid_580156 = path.getOrDefault("accountId")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = nil)
  if valid_580156 != nil:
    section.add "accountId", valid_580156
  var valid_580157 = path.getOrDefault("adClientId")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "adClientId", valid_580157
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
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
  var valid_580159 = query.getOrDefault("pageToken")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "pageToken", valid_580159
  var valid_580160 = query.getOrDefault("quotaUser")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "quotaUser", valid_580160
  var valid_580161 = query.getOrDefault("alt")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("json"))
  if valid_580161 != nil:
    section.add "alt", valid_580161
  var valid_580162 = query.getOrDefault("oauth_token")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "oauth_token", valid_580162
  var valid_580163 = query.getOrDefault("userIp")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "userIp", valid_580163
  var valid_580164 = query.getOrDefault("maxResults")
  valid_580164 = validateParameter(valid_580164, JInt, required = false, default = nil)
  if valid_580164 != nil:
    section.add "maxResults", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580167: Call_AdsenseAccountsUrlchannelsList_580153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_AdsenseAccountsUrlchannelsList_580153;
          accountId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsUrlchannelsList
  ## List all URL channels in the specified ad client for the specified account.
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
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  add(query_580170, "fields", newJString(fields))
  add(query_580170, "pageToken", newJString(pageToken))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(path_580169, "accountId", newJString(accountId))
  add(query_580170, "userIp", newJString(userIp))
  add(query_580170, "maxResults", newJInt(maxResults))
  add(query_580170, "key", newJString(key))
  add(path_580169, "adClientId", newJString(adClientId))
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  result = call_580168.call(path_580169, query_580170, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_580153(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_580154,
    base: "/adsense/v1.4", url: url_AdsenseAccountsUrlchannelsList_580155,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_580171 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAlertsList_580173(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsAlertsList_580172(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for the specified AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to retrieve the alerts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580174 = path.getOrDefault("accountId")
  valid_580174 = validateParameter(valid_580174, JString, required = true,
                                 default = nil)
  if valid_580174 != nil:
    section.add "accountId", valid_580174
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
  var valid_580175 = query.getOrDefault("locale")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "locale", valid_580175
  var valid_580176 = query.getOrDefault("fields")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "fields", valid_580176
  var valid_580177 = query.getOrDefault("quotaUser")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "quotaUser", valid_580177
  var valid_580178 = query.getOrDefault("alt")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("json"))
  if valid_580178 != nil:
    section.add "alt", valid_580178
  var valid_580179 = query.getOrDefault("oauth_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "oauth_token", valid_580179
  var valid_580180 = query.getOrDefault("userIp")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "userIp", valid_580180
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580183: Call_AdsenseAccountsAlertsList_580171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_580183.validator(path, query, header, formData, body)
  let scheme = call_580183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580183.url(scheme.get, call_580183.host, call_580183.base,
                         call_580183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580183, url, valid)

proc call*(call_580184: Call_AdsenseAccountsAlertsList_580171; accountId: string;
          locale: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAlertsList
  ## List the alerts for the specified AdSense account.
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
  ##            : Account for which to retrieve the alerts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580185 = newJObject()
  var query_580186 = newJObject()
  add(query_580186, "locale", newJString(locale))
  add(query_580186, "fields", newJString(fields))
  add(query_580186, "quotaUser", newJString(quotaUser))
  add(query_580186, "alt", newJString(alt))
  add(query_580186, "oauth_token", newJString(oauthToken))
  add(path_580185, "accountId", newJString(accountId))
  add(query_580186, "userIp", newJString(userIp))
  add(query_580186, "key", newJString(key))
  add(query_580186, "prettyPrint", newJBool(prettyPrint))
  result = call_580184.call(path_580185, query_580186, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_580171(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_580172, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAlertsList_580173, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsDelete_580187 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsAlertsDelete_580189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAlertsDelete_580188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  ##   alertId: JString (required)
  ##          : Alert to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580190 = path.getOrDefault("accountId")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "accountId", valid_580190
  var valid_580191 = path.getOrDefault("alertId")
  valid_580191 = validateParameter(valid_580191, JString, required = true,
                                 default = nil)
  if valid_580191 != nil:
    section.add "alertId", valid_580191
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
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("quotaUser")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "quotaUser", valid_580193
  var valid_580194 = query.getOrDefault("alt")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("json"))
  if valid_580194 != nil:
    section.add "alt", valid_580194
  var valid_580195 = query.getOrDefault("oauth_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "oauth_token", valid_580195
  var valid_580196 = query.getOrDefault("userIp")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "userIp", valid_580196
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("prettyPrint")
  valid_580198 = validateParameter(valid_580198, JBool, required = false,
                                 default = newJBool(true))
  if valid_580198 != nil:
    section.add "prettyPrint", valid_580198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580199: Call_AdsenseAccountsAlertsDelete_580187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_AdsenseAccountsAlertsDelete_580187; accountId: string;
          alertId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAlertsDelete
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   alertId: string (required)
  ##          : Alert to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580201 = newJObject()
  var query_580202 = newJObject()
  add(query_580202, "fields", newJString(fields))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(path_580201, "accountId", newJString(accountId))
  add(query_580202, "userIp", newJString(userIp))
  add(query_580202, "key", newJString(key))
  add(path_580201, "alertId", newJString(alertId))
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  result = call_580200.call(path_580201, query_580202, nil, nil, nil)

var adsenseAccountsAlertsDelete* = Call_AdsenseAccountsAlertsDelete_580187(
    name: "adsenseAccountsAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts/{alertId}",
    validator: validate_AdsenseAccountsAlertsDelete_580188, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAlertsDelete_580189, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsPaymentsList_580203 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsPaymentsList_580205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/payments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsPaymentsList_580204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the payments for the specified AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to retrieve the payments.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580206 = path.getOrDefault("accountId")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "accountId", valid_580206
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
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
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
  var valid_580212 = query.getOrDefault("key")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "key", valid_580212
  var valid_580213 = query.getOrDefault("prettyPrint")
  valid_580213 = validateParameter(valid_580213, JBool, required = false,
                                 default = newJBool(true))
  if valid_580213 != nil:
    section.add "prettyPrint", valid_580213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580214: Call_AdsenseAccountsPaymentsList_580203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the payments for the specified AdSense account.
  ## 
  let valid = call_580214.validator(path, query, header, formData, body)
  let scheme = call_580214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580214.url(scheme.get, call_580214.host, call_580214.base,
                         call_580214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580214, url, valid)

proc call*(call_580215: Call_AdsenseAccountsPaymentsList_580203; accountId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsPaymentsList
  ## List the payments for the specified AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to retrieve the payments.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580216 = newJObject()
  var query_580217 = newJObject()
  add(query_580217, "fields", newJString(fields))
  add(query_580217, "quotaUser", newJString(quotaUser))
  add(query_580217, "alt", newJString(alt))
  add(query_580217, "oauth_token", newJString(oauthToken))
  add(path_580216, "accountId", newJString(accountId))
  add(query_580217, "userIp", newJString(userIp))
  add(query_580217, "key", newJString(key))
  add(query_580217, "prettyPrint", newJBool(prettyPrint))
  result = call_580215.call(path_580216, query_580217, nil, nil, nil)

var adsenseAccountsPaymentsList* = Call_AdsenseAccountsPaymentsList_580203(
    name: "adsenseAccountsPaymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/payments",
    validator: validate_AdsenseAccountsPaymentsList_580204, base: "/adsense/v1.4",
    url: url_AdsenseAccountsPaymentsList_580205, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_580218 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsReportsGenerate_580220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsReportsGenerate_580219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account upon which to report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580221 = path.getOrDefault("accountId")
  valid_580221 = validateParameter(valid_580221, JString, required = true,
                                 default = nil)
  if valid_580221 != nil:
    section.add "accountId", valid_580221
  result.add "path", section
  ## parameters in `query` object:
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
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
  ##   currency: JString
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
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
  var valid_580222 = query.getOrDefault("useTimezoneReporting")
  valid_580222 = validateParameter(valid_580222, JBool, required = false, default = nil)
  if valid_580222 != nil:
    section.add "useTimezoneReporting", valid_580222
  var valid_580223 = query.getOrDefault("locale")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "locale", valid_580223
  var valid_580224 = query.getOrDefault("fields")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "fields", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  var valid_580226 = query.getOrDefault("alt")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("json"))
  if valid_580226 != nil:
    section.add "alt", valid_580226
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580227 = query.getOrDefault("endDate")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "endDate", valid_580227
  var valid_580228 = query.getOrDefault("currency")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "currency", valid_580228
  var valid_580229 = query.getOrDefault("startDate")
  valid_580229 = validateParameter(valid_580229, JString, required = true,
                                 default = nil)
  if valid_580229 != nil:
    section.add "startDate", valid_580229
  var valid_580230 = query.getOrDefault("sort")
  valid_580230 = validateParameter(valid_580230, JArray, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "sort", valid_580230
  var valid_580231 = query.getOrDefault("oauth_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "oauth_token", valid_580231
  var valid_580232 = query.getOrDefault("userIp")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "userIp", valid_580232
  var valid_580233 = query.getOrDefault("maxResults")
  valid_580233 = validateParameter(valid_580233, JInt, required = false, default = nil)
  if valid_580233 != nil:
    section.add "maxResults", valid_580233
  var valid_580234 = query.getOrDefault("key")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "key", valid_580234
  var valid_580235 = query.getOrDefault("metric")
  valid_580235 = validateParameter(valid_580235, JArray, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "metric", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  var valid_580237 = query.getOrDefault("dimension")
  valid_580237 = validateParameter(valid_580237, JArray, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "dimension", valid_580237
  var valid_580238 = query.getOrDefault("filter")
  valid_580238 = validateParameter(valid_580238, JArray, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "filter", valid_580238
  var valid_580239 = query.getOrDefault("startIndex")
  valid_580239 = validateParameter(valid_580239, JInt, required = false, default = nil)
  if valid_580239 != nil:
    section.add "startIndex", valid_580239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580240: Call_AdsenseAccountsReportsGenerate_580218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580240.validator(path, query, header, formData, body)
  let scheme = call_580240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580240.url(scheme.get, call_580240.host, call_580240.base,
                         call_580240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580240, url, valid)

proc call*(call_580241: Call_AdsenseAccountsReportsGenerate_580218;
          endDate: string; startDate: string; accountId: string;
          useTimezoneReporting: bool = false; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; currency: string = "";
          sort: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; metric: JsonNode = nil;
          prettyPrint: bool = true; dimension: JsonNode = nil; filter: JsonNode = nil;
          startIndex: int = 0): Recallable =
  ## adsenseAccountsReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   useTimezoneReporting: bool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
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
  ##   currency: string
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account upon which to report.
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
  var path_580242 = newJObject()
  var query_580243 = newJObject()
  add(query_580243, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_580243, "locale", newJString(locale))
  add(query_580243, "fields", newJString(fields))
  add(query_580243, "quotaUser", newJString(quotaUser))
  add(query_580243, "alt", newJString(alt))
  add(query_580243, "endDate", newJString(endDate))
  add(query_580243, "currency", newJString(currency))
  add(query_580243, "startDate", newJString(startDate))
  if sort != nil:
    query_580243.add "sort", sort
  add(query_580243, "oauth_token", newJString(oauthToken))
  add(path_580242, "accountId", newJString(accountId))
  add(query_580243, "userIp", newJString(userIp))
  add(query_580243, "maxResults", newJInt(maxResults))
  add(query_580243, "key", newJString(key))
  if metric != nil:
    query_580243.add "metric", metric
  add(query_580243, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580243.add "dimension", dimension
  if filter != nil:
    query_580243.add "filter", filter
  add(query_580243, "startIndex", newJInt(startIndex))
  result = call_580241.call(path_580242, query_580243, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_580218(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_580219,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsGenerate_580220,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_580244 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsReportsSavedList_580246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsReportsSavedList_580245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in the specified AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the saved reports belong.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580247 = path.getOrDefault("accountId")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "accountId", valid_580247
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
  var valid_580248 = query.getOrDefault("fields")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "fields", valid_580248
  var valid_580249 = query.getOrDefault("pageToken")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "pageToken", valid_580249
  var valid_580250 = query.getOrDefault("quotaUser")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "quotaUser", valid_580250
  var valid_580251 = query.getOrDefault("alt")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = newJString("json"))
  if valid_580251 != nil:
    section.add "alt", valid_580251
  var valid_580252 = query.getOrDefault("oauth_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "oauth_token", valid_580252
  var valid_580253 = query.getOrDefault("userIp")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "userIp", valid_580253
  var valid_580254 = query.getOrDefault("maxResults")
  valid_580254 = validateParameter(valid_580254, JInt, required = false, default = nil)
  if valid_580254 != nil:
    section.add "maxResults", valid_580254
  var valid_580255 = query.getOrDefault("key")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "key", valid_580255
  var valid_580256 = query.getOrDefault("prettyPrint")
  valid_580256 = validateParameter(valid_580256, JBool, required = false,
                                 default = newJBool(true))
  if valid_580256 != nil:
    section.add "prettyPrint", valid_580256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580257: Call_AdsenseAccountsReportsSavedList_580244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_AdsenseAccountsReportsSavedList_580244;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsReportsSavedList
  ## List all saved reports in the specified AdSense account.
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
  ##            : Account to which the saved reports belong.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580259 = newJObject()
  var query_580260 = newJObject()
  add(query_580260, "fields", newJString(fields))
  add(query_580260, "pageToken", newJString(pageToken))
  add(query_580260, "quotaUser", newJString(quotaUser))
  add(query_580260, "alt", newJString(alt))
  add(query_580260, "oauth_token", newJString(oauthToken))
  add(path_580259, "accountId", newJString(accountId))
  add(query_580260, "userIp", newJString(userIp))
  add(query_580260, "maxResults", newJInt(maxResults))
  add(query_580260, "key", newJString(key))
  add(query_580260, "prettyPrint", newJBool(prettyPrint))
  result = call_580258.call(path_580259, query_580260, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_580244(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_580245,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsSavedList_580246,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_580261 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsReportsSavedGenerate_580263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AdsenseAccountsReportsSavedGenerate_580262(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to which the saved reports belong.
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580264 = path.getOrDefault("accountId")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "accountId", valid_580264
  var valid_580265 = path.getOrDefault("savedReportId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "savedReportId", valid_580265
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
  var valid_580266 = query.getOrDefault("locale")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "locale", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("userIp")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "userIp", valid_580271
  var valid_580272 = query.getOrDefault("maxResults")
  valid_580272 = validateParameter(valid_580272, JInt, required = false, default = nil)
  if valid_580272 != nil:
    section.add "maxResults", valid_580272
  var valid_580273 = query.getOrDefault("key")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "key", valid_580273
  var valid_580274 = query.getOrDefault("prettyPrint")
  valid_580274 = validateParameter(valid_580274, JBool, required = false,
                                 default = newJBool(true))
  if valid_580274 != nil:
    section.add "prettyPrint", valid_580274
  var valid_580275 = query.getOrDefault("startIndex")
  valid_580275 = validateParameter(valid_580275, JInt, required = false, default = nil)
  if valid_580275 != nil:
    section.add "startIndex", valid_580275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580276: Call_AdsenseAccountsReportsSavedGenerate_580261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_580276.validator(path, query, header, formData, body)
  let scheme = call_580276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580276.url(scheme.get, call_580276.host, call_580276.base,
                         call_580276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580276, url, valid)

proc call*(call_580277: Call_AdsenseAccountsReportsSavedGenerate_580261;
          accountId: string; savedReportId: string; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adsenseAccountsReportsSavedGenerate
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
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
  ##            : Account to which the saved reports belong.
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
  var path_580278 = newJObject()
  var query_580279 = newJObject()
  add(query_580279, "locale", newJString(locale))
  add(query_580279, "fields", newJString(fields))
  add(query_580279, "quotaUser", newJString(quotaUser))
  add(query_580279, "alt", newJString(alt))
  add(query_580279, "oauth_token", newJString(oauthToken))
  add(path_580278, "accountId", newJString(accountId))
  add(query_580279, "userIp", newJString(userIp))
  add(query_580279, "maxResults", newJInt(maxResults))
  add(path_580278, "savedReportId", newJString(savedReportId))
  add(query_580279, "key", newJString(key))
  add(query_580279, "prettyPrint", newJBool(prettyPrint))
  add(query_580279, "startIndex", newJInt(startIndex))
  result = call_580277.call(path_580278, query_580279, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_580261(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_580262,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsSavedGenerate_580263,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_580280 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsSavedadstylesList_580282(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/savedadstyles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsSavedadstylesList_580281(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved ad styles in the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list saved ad styles.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580283 = path.getOrDefault("accountId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "accountId", valid_580283
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580284 = query.getOrDefault("fields")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "fields", valid_580284
  var valid_580285 = query.getOrDefault("pageToken")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "pageToken", valid_580285
  var valid_580286 = query.getOrDefault("quotaUser")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "quotaUser", valid_580286
  var valid_580287 = query.getOrDefault("alt")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = newJString("json"))
  if valid_580287 != nil:
    section.add "alt", valid_580287
  var valid_580288 = query.getOrDefault("oauth_token")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "oauth_token", valid_580288
  var valid_580289 = query.getOrDefault("userIp")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "userIp", valid_580289
  var valid_580290 = query.getOrDefault("maxResults")
  valid_580290 = validateParameter(valid_580290, JInt, required = false, default = nil)
  if valid_580290 != nil:
    section.add "maxResults", valid_580290
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("prettyPrint")
  valid_580292 = validateParameter(valid_580292, JBool, required = false,
                                 default = newJBool(true))
  if valid_580292 != nil:
    section.add "prettyPrint", valid_580292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580293: Call_AdsenseAccountsSavedadstylesList_580280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_AdsenseAccountsSavedadstylesList_580280;
          accountId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsSavedadstylesList
  ## List all saved ad styles in the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to list saved ad styles.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "pageToken", newJString(pageToken))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(path_580295, "accountId", newJString(accountId))
  add(query_580296, "userIp", newJString(userIp))
  add(query_580296, "maxResults", newJInt(maxResults))
  add(query_580296, "key", newJString(key))
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  result = call_580294.call(path_580295, query_580296, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_580280(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_580281,
    base: "/adsense/v1.4", url: url_AdsenseAccountsSavedadstylesList_580282,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_580297 = ref object of OpenApiRestCall_579424
proc url_AdsenseAccountsSavedadstylesGet_580299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "savedAdStyleId" in path, "`savedAdStyleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/savedadstyles/"),
               (kind: VariableSegment, value: "savedAdStyleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsSavedadstylesGet_580298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List a specific saved ad style for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to get the saved ad style.
  ##   savedAdStyleId: JString (required)
  ##                 : Saved ad style to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580300 = path.getOrDefault("accountId")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "accountId", valid_580300
  var valid_580301 = path.getOrDefault("savedAdStyleId")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "savedAdStyleId", valid_580301
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
  var valid_580302 = query.getOrDefault("fields")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fields", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("oauth_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "oauth_token", valid_580305
  var valid_580306 = query.getOrDefault("userIp")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "userIp", valid_580306
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("prettyPrint")
  valid_580308 = validateParameter(valid_580308, JBool, required = false,
                                 default = newJBool(true))
  if valid_580308 != nil:
    section.add "prettyPrint", valid_580308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580309: Call_AdsenseAccountsSavedadstylesGet_580297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_580309.validator(path, query, header, formData, body)
  let scheme = call_580309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580309.url(scheme.get, call_580309.host, call_580309.base,
                         call_580309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580309, url, valid)

proc call*(call_580310: Call_AdsenseAccountsSavedadstylesGet_580297;
          accountId: string; savedAdStyleId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsSavedadstylesGet
  ## List a specific saved ad style for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to get the saved ad style.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580311 = newJObject()
  var query_580312 = newJObject()
  add(query_580312, "fields", newJString(fields))
  add(query_580312, "quotaUser", newJString(quotaUser))
  add(query_580312, "alt", newJString(alt))
  add(query_580312, "oauth_token", newJString(oauthToken))
  add(path_580311, "accountId", newJString(accountId))
  add(path_580311, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_580312, "userIp", newJString(userIp))
  add(query_580312, "key", newJString(key))
  add(query_580312, "prettyPrint", newJBool(prettyPrint))
  result = call_580310.call(path_580311, query_580312, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_580297(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_580298,
    base: "/adsense/v1.4", url: url_AdsenseAccountsSavedadstylesGet_580299,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_580313 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdclientsList_580315(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_580314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this AdSense account.
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
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("pageToken")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "pageToken", valid_580317
  var valid_580318 = query.getOrDefault("quotaUser")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "quotaUser", valid_580318
  var valid_580319 = query.getOrDefault("alt")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("json"))
  if valid_580319 != nil:
    section.add "alt", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("userIp")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "userIp", valid_580321
  var valid_580322 = query.getOrDefault("maxResults")
  valid_580322 = validateParameter(valid_580322, JInt, required = false, default = nil)
  if valid_580322 != nil:
    section.add "maxResults", valid_580322
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580325: Call_AdsenseAdclientsList_580313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_580325.validator(path, query, header, formData, body)
  let scheme = call_580325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580325.url(scheme.get, call_580325.host, call_580325.base,
                         call_580325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580325, url, valid)

proc call*(call_580326: Call_AdsenseAdclientsList_580313; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdclientsList
  ## List all ad clients in this AdSense account.
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
  var query_580327 = newJObject()
  add(query_580327, "fields", newJString(fields))
  add(query_580327, "pageToken", newJString(pageToken))
  add(query_580327, "quotaUser", newJString(quotaUser))
  add(query_580327, "alt", newJString(alt))
  add(query_580327, "oauth_token", newJString(oauthToken))
  add(query_580327, "userIp", newJString(userIp))
  add(query_580327, "maxResults", newJInt(maxResults))
  add(query_580327, "key", newJString(key))
  add(query_580327, "prettyPrint", newJBool(prettyPrint))
  result = call_580326.call(nil, query_580327, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_580313(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_580314, base: "/adsense/v1.4",
    url: url_AdsenseAdclientsList_580315, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_580328 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsList_580330(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAdunitsList_580329(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580331 = path.getOrDefault("adClientId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "adClientId", valid_580331
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
  var valid_580332 = query.getOrDefault("fields")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "fields", valid_580332
  var valid_580333 = query.getOrDefault("pageToken")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "pageToken", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("includeInactive")
  valid_580336 = validateParameter(valid_580336, JBool, required = false, default = nil)
  if valid_580336 != nil:
    section.add "includeInactive", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("userIp")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "userIp", valid_580338
  var valid_580339 = query.getOrDefault("maxResults")
  valid_580339 = validateParameter(valid_580339, JInt, required = false, default = nil)
  if valid_580339 != nil:
    section.add "maxResults", valid_580339
  var valid_580340 = query.getOrDefault("key")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "key", valid_580340
  var valid_580341 = query.getOrDefault("prettyPrint")
  valid_580341 = validateParameter(valid_580341, JBool, required = false,
                                 default = newJBool(true))
  if valid_580341 != nil:
    section.add "prettyPrint", valid_580341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580342: Call_AdsenseAdunitsList_580328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_580342.validator(path, query, header, formData, body)
  let scheme = call_580342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580342.url(scheme.get, call_580342.host, call_580342.base,
                         call_580342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580342, url, valid)

proc call*(call_580343: Call_AdsenseAdunitsList_580328; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; includeInactive: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsList
  ## List all ad units in the specified ad client for this AdSense account.
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
  var path_580344 = newJObject()
  var query_580345 = newJObject()
  add(query_580345, "fields", newJString(fields))
  add(query_580345, "pageToken", newJString(pageToken))
  add(query_580345, "quotaUser", newJString(quotaUser))
  add(query_580345, "alt", newJString(alt))
  add(query_580345, "includeInactive", newJBool(includeInactive))
  add(query_580345, "oauth_token", newJString(oauthToken))
  add(query_580345, "userIp", newJString(userIp))
  add(query_580345, "maxResults", newJInt(maxResults))
  add(query_580345, "key", newJString(key))
  add(path_580344, "adClientId", newJString(adClientId))
  add(query_580345, "prettyPrint", newJBool(prettyPrint))
  result = call_580343.call(path_580344, query_580345, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_580328(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_580329, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsList_580330, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_580346 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsGet_580348(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAdunitsGet_580347(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
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
  var valid_580349 = path.getOrDefault("adClientId")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "adClientId", valid_580349
  var valid_580350 = path.getOrDefault("adUnitId")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "adUnitId", valid_580350
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
  var valid_580351 = query.getOrDefault("fields")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "fields", valid_580351
  var valid_580352 = query.getOrDefault("quotaUser")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "quotaUser", valid_580352
  var valid_580353 = query.getOrDefault("alt")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = newJString("json"))
  if valid_580353 != nil:
    section.add "alt", valid_580353
  var valid_580354 = query.getOrDefault("oauth_token")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "oauth_token", valid_580354
  var valid_580355 = query.getOrDefault("userIp")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "userIp", valid_580355
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("prettyPrint")
  valid_580357 = validateParameter(valid_580357, JBool, required = false,
                                 default = newJBool(true))
  if valid_580357 != nil:
    section.add "prettyPrint", valid_580357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580358: Call_AdsenseAdunitsGet_580346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_580358.validator(path, query, header, formData, body)
  let scheme = call_580358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580358.url(scheme.get, call_580358.host, call_580358.base,
                         call_580358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580358, url, valid)

proc call*(call_580359: Call_AdsenseAdunitsGet_580346; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsGet
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
  var path_580360 = newJObject()
  var query_580361 = newJObject()
  add(query_580361, "fields", newJString(fields))
  add(query_580361, "quotaUser", newJString(quotaUser))
  add(query_580361, "alt", newJString(alt))
  add(query_580361, "oauth_token", newJString(oauthToken))
  add(query_580361, "userIp", newJString(userIp))
  add(query_580361, "key", newJString(key))
  add(path_580360, "adClientId", newJString(adClientId))
  add(path_580360, "adUnitId", newJString(adUnitId))
  add(query_580361, "prettyPrint", newJBool(prettyPrint))
  result = call_580359.call(path_580360, query_580361, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_580346(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_580347, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsGet_580348, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_580362 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsGetAdCode_580364(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsGetAdCode_580363(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get the code for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580365 = path.getOrDefault("adClientId")
  valid_580365 = validateParameter(valid_580365, JString, required = true,
                                 default = nil)
  if valid_580365 != nil:
    section.add "adClientId", valid_580365
  var valid_580366 = path.getOrDefault("adUnitId")
  valid_580366 = validateParameter(valid_580366, JString, required = true,
                                 default = nil)
  if valid_580366 != nil:
    section.add "adUnitId", valid_580366
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
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("alt")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("json"))
  if valid_580369 != nil:
    section.add "alt", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("userIp")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "userIp", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580374: Call_AdsenseAdunitsGetAdCode_580362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_AdsenseAdunitsGetAdCode_580362; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
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
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  add(query_580377, "fields", newJString(fields))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(query_580377, "userIp", newJString(userIp))
  add(query_580377, "key", newJString(key))
  add(path_580376, "adClientId", newJString(adClientId))
  add(path_580376, "adUnitId", newJString(adUnitId))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  result = call_580375.call(path_580376, query_580377, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_580362(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_580363, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsGetAdCode_580364, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_580378 = ref object of OpenApiRestCall_579424
proc url_AdsenseAdunitsCustomchannelsList_580380(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsCustomchannelsList_580379(path: JsonNode;
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
  var valid_580381 = path.getOrDefault("adClientId")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "adClientId", valid_580381
  var valid_580382 = path.getOrDefault("adUnitId")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "adUnitId", valid_580382
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
  var valid_580383 = query.getOrDefault("fields")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "fields", valid_580383
  var valid_580384 = query.getOrDefault("pageToken")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "pageToken", valid_580384
  var valid_580385 = query.getOrDefault("quotaUser")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "quotaUser", valid_580385
  var valid_580386 = query.getOrDefault("alt")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("json"))
  if valid_580386 != nil:
    section.add "alt", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("maxResults")
  valid_580389 = validateParameter(valid_580389, JInt, required = false, default = nil)
  if valid_580389 != nil:
    section.add "maxResults", valid_580389
  var valid_580390 = query.getOrDefault("key")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "key", valid_580390
  var valid_580391 = query.getOrDefault("prettyPrint")
  valid_580391 = validateParameter(valid_580391, JBool, required = false,
                                 default = newJBool(true))
  if valid_580391 != nil:
    section.add "prettyPrint", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580392: Call_AdsenseAdunitsCustomchannelsList_580378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_AdsenseAdunitsCustomchannelsList_580378;
          adClientId: string; adUnitId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsCustomchannelsList
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
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  add(query_580395, "fields", newJString(fields))
  add(query_580395, "pageToken", newJString(pageToken))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(query_580395, "userIp", newJString(userIp))
  add(query_580395, "maxResults", newJInt(maxResults))
  add(query_580395, "key", newJString(key))
  add(path_580394, "adClientId", newJString(adClientId))
  add(path_580394, "adUnitId", newJString(adUnitId))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  result = call_580393.call(path_580394, query_580395, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_580378(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_580379,
    base: "/adsense/v1.4", url: url_AdsenseAdunitsCustomchannelsList_580380,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_580396 = ref object of OpenApiRestCall_579424
proc url_AdsenseCustomchannelsList_580398(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsList_580397(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580399 = path.getOrDefault("adClientId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "adClientId", valid_580399
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
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  var valid_580401 = query.getOrDefault("pageToken")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "pageToken", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("oauth_token")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "oauth_token", valid_580404
  var valid_580405 = query.getOrDefault("userIp")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "userIp", valid_580405
  var valid_580406 = query.getOrDefault("maxResults")
  valid_580406 = validateParameter(valid_580406, JInt, required = false, default = nil)
  if valid_580406 != nil:
    section.add "maxResults", valid_580406
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580409: Call_AdsenseCustomchannelsList_580396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_580409.validator(path, query, header, formData, body)
  let scheme = call_580409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580409.url(scheme.get, call_580409.host, call_580409.base,
                         call_580409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580409, url, valid)

proc call*(call_580410: Call_AdsenseCustomchannelsList_580396; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsList
  ## List all custom channels in the specified ad client for this AdSense account.
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
  var path_580411 = newJObject()
  var query_580412 = newJObject()
  add(query_580412, "fields", newJString(fields))
  add(query_580412, "pageToken", newJString(pageToken))
  add(query_580412, "quotaUser", newJString(quotaUser))
  add(query_580412, "alt", newJString(alt))
  add(query_580412, "oauth_token", newJString(oauthToken))
  add(query_580412, "userIp", newJString(userIp))
  add(query_580412, "maxResults", newJInt(maxResults))
  add(query_580412, "key", newJString(key))
  add(path_580411, "adClientId", newJString(adClientId))
  add(query_580412, "prettyPrint", newJBool(prettyPrint))
  result = call_580410.call(path_580411, query_580412, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_580396(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_580397, base: "/adsense/v1.4",
    url: url_AdsenseCustomchannelsList_580398, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_580413 = ref object of OpenApiRestCall_579424
proc url_AdsenseCustomchannelsGet_580415(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_AdsenseCustomchannelsGet_580414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580416 = path.getOrDefault("customChannelId")
  valid_580416 = validateParameter(valid_580416, JString, required = true,
                                 default = nil)
  if valid_580416 != nil:
    section.add "customChannelId", valid_580416
  var valid_580417 = path.getOrDefault("adClientId")
  valid_580417 = validateParameter(valid_580417, JString, required = true,
                                 default = nil)
  if valid_580417 != nil:
    section.add "adClientId", valid_580417
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
  var valid_580418 = query.getOrDefault("fields")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "fields", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("alt")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = newJString("json"))
  if valid_580420 != nil:
    section.add "alt", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("userIp")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "userIp", valid_580422
  var valid_580423 = query.getOrDefault("key")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "key", valid_580423
  var valid_580424 = query.getOrDefault("prettyPrint")
  valid_580424 = validateParameter(valid_580424, JBool, required = false,
                                 default = newJBool(true))
  if valid_580424 != nil:
    section.add "prettyPrint", valid_580424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580425: Call_AdsenseCustomchannelsGet_580413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_580425.validator(path, query, header, formData, body)
  let scheme = call_580425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580425.url(scheme.get, call_580425.host, call_580425.base,
                         call_580425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580425, url, valid)

proc call*(call_580426: Call_AdsenseCustomchannelsGet_580413;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsGet
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
  var path_580427 = newJObject()
  var query_580428 = newJObject()
  add(query_580428, "fields", newJString(fields))
  add(query_580428, "quotaUser", newJString(quotaUser))
  add(query_580428, "alt", newJString(alt))
  add(query_580428, "oauth_token", newJString(oauthToken))
  add(path_580427, "customChannelId", newJString(customChannelId))
  add(query_580428, "userIp", newJString(userIp))
  add(query_580428, "key", newJString(key))
  add(path_580427, "adClientId", newJString(adClientId))
  add(query_580428, "prettyPrint", newJBool(prettyPrint))
  result = call_580426.call(path_580427, query_580428, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_580413(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_580414, base: "/adsense/v1.4",
    url: url_AdsenseCustomchannelsGet_580415, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_580429 = ref object of OpenApiRestCall_579424
proc url_AdsenseCustomchannelsAdunitsList_580431(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseCustomchannelsAdunitsList_580430(path: JsonNode;
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
  var valid_580432 = path.getOrDefault("customChannelId")
  valid_580432 = validateParameter(valid_580432, JString, required = true,
                                 default = nil)
  if valid_580432 != nil:
    section.add "customChannelId", valid_580432
  var valid_580433 = path.getOrDefault("adClientId")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "adClientId", valid_580433
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
  var valid_580434 = query.getOrDefault("fields")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "fields", valid_580434
  var valid_580435 = query.getOrDefault("pageToken")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "pageToken", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("alt")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = newJString("json"))
  if valid_580437 != nil:
    section.add "alt", valid_580437
  var valid_580438 = query.getOrDefault("includeInactive")
  valid_580438 = validateParameter(valid_580438, JBool, required = false, default = nil)
  if valid_580438 != nil:
    section.add "includeInactive", valid_580438
  var valid_580439 = query.getOrDefault("oauth_token")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "oauth_token", valid_580439
  var valid_580440 = query.getOrDefault("userIp")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "userIp", valid_580440
  var valid_580441 = query.getOrDefault("maxResults")
  valid_580441 = validateParameter(valid_580441, JInt, required = false, default = nil)
  if valid_580441 != nil:
    section.add "maxResults", valid_580441
  var valid_580442 = query.getOrDefault("key")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "key", valid_580442
  var valid_580443 = query.getOrDefault("prettyPrint")
  valid_580443 = validateParameter(valid_580443, JBool, required = false,
                                 default = newJBool(true))
  if valid_580443 != nil:
    section.add "prettyPrint", valid_580443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580444: Call_AdsenseCustomchannelsAdunitsList_580429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_580444.validator(path, query, header, formData, body)
  let scheme = call_580444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580444.url(scheme.get, call_580444.host, call_580444.base,
                         call_580444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580444, url, valid)

proc call*(call_580445: Call_AdsenseCustomchannelsAdunitsList_580429;
          customChannelId: string; adClientId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          includeInactive: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsAdunitsList
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
  var path_580446 = newJObject()
  var query_580447 = newJObject()
  add(query_580447, "fields", newJString(fields))
  add(query_580447, "pageToken", newJString(pageToken))
  add(query_580447, "quotaUser", newJString(quotaUser))
  add(query_580447, "alt", newJString(alt))
  add(query_580447, "includeInactive", newJBool(includeInactive))
  add(query_580447, "oauth_token", newJString(oauthToken))
  add(path_580446, "customChannelId", newJString(customChannelId))
  add(query_580447, "userIp", newJString(userIp))
  add(query_580447, "maxResults", newJInt(maxResults))
  add(query_580447, "key", newJString(key))
  add(path_580446, "adClientId", newJString(adClientId))
  add(query_580447, "prettyPrint", newJBool(prettyPrint))
  result = call_580445.call(path_580446, query_580447, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_580429(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_580430,
    base: "/adsense/v1.4", url: url_AdsenseCustomchannelsAdunitsList_580431,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_580448 = ref object of OpenApiRestCall_579424
proc url_AdsenseUrlchannelsList_580450(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseUrlchannelsList_580449(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_580451 = path.getOrDefault("adClientId")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "adClientId", valid_580451
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
  var valid_580452 = query.getOrDefault("fields")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "fields", valid_580452
  var valid_580453 = query.getOrDefault("pageToken")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "pageToken", valid_580453
  var valid_580454 = query.getOrDefault("quotaUser")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "quotaUser", valid_580454
  var valid_580455 = query.getOrDefault("alt")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = newJString("json"))
  if valid_580455 != nil:
    section.add "alt", valid_580455
  var valid_580456 = query.getOrDefault("oauth_token")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "oauth_token", valid_580456
  var valid_580457 = query.getOrDefault("userIp")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "userIp", valid_580457
  var valid_580458 = query.getOrDefault("maxResults")
  valid_580458 = validateParameter(valid_580458, JInt, required = false, default = nil)
  if valid_580458 != nil:
    section.add "maxResults", valid_580458
  var valid_580459 = query.getOrDefault("key")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "key", valid_580459
  var valid_580460 = query.getOrDefault("prettyPrint")
  valid_580460 = validateParameter(valid_580460, JBool, required = false,
                                 default = newJBool(true))
  if valid_580460 != nil:
    section.add "prettyPrint", valid_580460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580461: Call_AdsenseUrlchannelsList_580448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_580461.validator(path, query, header, formData, body)
  let scheme = call_580461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580461.url(scheme.get, call_580461.host, call_580461.base,
                         call_580461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580461, url, valid)

proc call*(call_580462: Call_AdsenseUrlchannelsList_580448; adClientId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseUrlchannelsList
  ## List all URL channels in the specified ad client for this AdSense account.
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
  var path_580463 = newJObject()
  var query_580464 = newJObject()
  add(query_580464, "fields", newJString(fields))
  add(query_580464, "pageToken", newJString(pageToken))
  add(query_580464, "quotaUser", newJString(quotaUser))
  add(query_580464, "alt", newJString(alt))
  add(query_580464, "oauth_token", newJString(oauthToken))
  add(query_580464, "userIp", newJString(userIp))
  add(query_580464, "maxResults", newJInt(maxResults))
  add(query_580464, "key", newJString(key))
  add(path_580463, "adClientId", newJString(adClientId))
  add(query_580464, "prettyPrint", newJBool(prettyPrint))
  result = call_580462.call(path_580463, query_580464, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_580448(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_580449, base: "/adsense/v1.4",
    url: url_AdsenseUrlchannelsList_580450, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_580465 = ref object of OpenApiRestCall_579424
proc url_AdsenseAlertsList_580467(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_580466(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List the alerts for this AdSense account.
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
  var valid_580468 = query.getOrDefault("locale")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "locale", valid_580468
  var valid_580469 = query.getOrDefault("fields")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "fields", valid_580469
  var valid_580470 = query.getOrDefault("quotaUser")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "quotaUser", valid_580470
  var valid_580471 = query.getOrDefault("alt")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = newJString("json"))
  if valid_580471 != nil:
    section.add "alt", valid_580471
  var valid_580472 = query.getOrDefault("oauth_token")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "oauth_token", valid_580472
  var valid_580473 = query.getOrDefault("userIp")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "userIp", valid_580473
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580476: Call_AdsenseAlertsList_580465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_580476.validator(path, query, header, formData, body)
  let scheme = call_580476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580476.url(scheme.get, call_580476.host, call_580476.base,
                         call_580476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580476, url, valid)

proc call*(call_580477: Call_AdsenseAlertsList_580465; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAlertsList
  ## List the alerts for this AdSense account.
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
  var query_580478 = newJObject()
  add(query_580478, "locale", newJString(locale))
  add(query_580478, "fields", newJString(fields))
  add(query_580478, "quotaUser", newJString(quotaUser))
  add(query_580478, "alt", newJString(alt))
  add(query_580478, "oauth_token", newJString(oauthToken))
  add(query_580478, "userIp", newJString(userIp))
  add(query_580478, "key", newJString(key))
  add(query_580478, "prettyPrint", newJBool(prettyPrint))
  result = call_580477.call(nil, query_580478, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_580465(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_580466, base: "/adsense/v1.4",
    url: url_AdsenseAlertsList_580467, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsDelete_580479 = ref object of OpenApiRestCall_579424
proc url_AdsenseAlertsDelete_580481(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAlertsDelete_580480(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Dismiss (delete) the specified alert from the publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_580482 = path.getOrDefault("alertId")
  valid_580482 = validateParameter(valid_580482, JString, required = true,
                                 default = nil)
  if valid_580482 != nil:
    section.add "alertId", valid_580482
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
  var valid_580483 = query.getOrDefault("fields")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "fields", valid_580483
  var valid_580484 = query.getOrDefault("quotaUser")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "quotaUser", valid_580484
  var valid_580485 = query.getOrDefault("alt")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("json"))
  if valid_580485 != nil:
    section.add "alt", valid_580485
  var valid_580486 = query.getOrDefault("oauth_token")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "oauth_token", valid_580486
  var valid_580487 = query.getOrDefault("userIp")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "userIp", valid_580487
  var valid_580488 = query.getOrDefault("key")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "key", valid_580488
  var valid_580489 = query.getOrDefault("prettyPrint")
  valid_580489 = validateParameter(valid_580489, JBool, required = false,
                                 default = newJBool(true))
  if valid_580489 != nil:
    section.add "prettyPrint", valid_580489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580490: Call_AdsenseAlertsDelete_580479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss (delete) the specified alert from the publisher's AdSense account.
  ## 
  let valid = call_580490.validator(path, query, header, formData, body)
  let scheme = call_580490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580490.url(scheme.get, call_580490.host, call_580490.base,
                         call_580490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580490, url, valid)

proc call*(call_580491: Call_AdsenseAlertsDelete_580479; alertId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAlertsDelete
  ## Dismiss (delete) the specified alert from the publisher's AdSense account.
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
  ##   alertId: string (required)
  ##          : Alert to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580492 = newJObject()
  var query_580493 = newJObject()
  add(query_580493, "fields", newJString(fields))
  add(query_580493, "quotaUser", newJString(quotaUser))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "userIp", newJString(userIp))
  add(query_580493, "key", newJString(key))
  add(path_580492, "alertId", newJString(alertId))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  result = call_580491.call(path_580492, query_580493, nil, nil, nil)

var adsenseAlertsDelete* = Call_AdsenseAlertsDelete_580479(
    name: "adsenseAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/alerts/{alertId}",
    validator: validate_AdsenseAlertsDelete_580480, base: "/adsense/v1.4",
    url: url_AdsenseAlertsDelete_580481, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_580494 = ref object of OpenApiRestCall_579424
proc url_AdsenseMetadataDimensionsList_580496(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_580495(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdSense account.
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
  var valid_580497 = query.getOrDefault("fields")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "fields", valid_580497
  var valid_580498 = query.getOrDefault("quotaUser")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "quotaUser", valid_580498
  var valid_580499 = query.getOrDefault("alt")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = newJString("json"))
  if valid_580499 != nil:
    section.add "alt", valid_580499
  var valid_580500 = query.getOrDefault("oauth_token")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "oauth_token", valid_580500
  var valid_580501 = query.getOrDefault("userIp")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "userIp", valid_580501
  var valid_580502 = query.getOrDefault("key")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "key", valid_580502
  var valid_580503 = query.getOrDefault("prettyPrint")
  valid_580503 = validateParameter(valid_580503, JBool, required = false,
                                 default = newJBool(true))
  if valid_580503 != nil:
    section.add "prettyPrint", valid_580503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580504: Call_AdsenseMetadataDimensionsList_580494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_580504.validator(path, query, header, formData, body)
  let scheme = call_580504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580504.url(scheme.get, call_580504.host, call_580504.base,
                         call_580504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580504, url, valid)

proc call*(call_580505: Call_AdsenseMetadataDimensionsList_580494;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdSense account.
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
  var query_580506 = newJObject()
  add(query_580506, "fields", newJString(fields))
  add(query_580506, "quotaUser", newJString(quotaUser))
  add(query_580506, "alt", newJString(alt))
  add(query_580506, "oauth_token", newJString(oauthToken))
  add(query_580506, "userIp", newJString(userIp))
  add(query_580506, "key", newJString(key))
  add(query_580506, "prettyPrint", newJBool(prettyPrint))
  result = call_580505.call(nil, query_580506, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_580494(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_580495,
    base: "/adsense/v1.4", url: url_AdsenseMetadataDimensionsList_580496,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_580507 = ref object of OpenApiRestCall_579424
proc url_AdsenseMetadataMetricsList_580509(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_580508(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdSense account.
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
  var valid_580510 = query.getOrDefault("fields")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "fields", valid_580510
  var valid_580511 = query.getOrDefault("quotaUser")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "quotaUser", valid_580511
  var valid_580512 = query.getOrDefault("alt")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = newJString("json"))
  if valid_580512 != nil:
    section.add "alt", valid_580512
  var valid_580513 = query.getOrDefault("oauth_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "oauth_token", valid_580513
  var valid_580514 = query.getOrDefault("userIp")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "userIp", valid_580514
  var valid_580515 = query.getOrDefault("key")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "key", valid_580515
  var valid_580516 = query.getOrDefault("prettyPrint")
  valid_580516 = validateParameter(valid_580516, JBool, required = false,
                                 default = newJBool(true))
  if valid_580516 != nil:
    section.add "prettyPrint", valid_580516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580517: Call_AdsenseMetadataMetricsList_580507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_580517.validator(path, query, header, formData, body)
  let scheme = call_580517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580517.url(scheme.get, call_580517.host, call_580517.base,
                         call_580517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580517, url, valid)

proc call*(call_580518: Call_AdsenseMetadataMetricsList_580507;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseMetadataMetricsList
  ## List the metadata for the metrics available to this AdSense account.
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
  var query_580519 = newJObject()
  add(query_580519, "fields", newJString(fields))
  add(query_580519, "quotaUser", newJString(quotaUser))
  add(query_580519, "alt", newJString(alt))
  add(query_580519, "oauth_token", newJString(oauthToken))
  add(query_580519, "userIp", newJString(userIp))
  add(query_580519, "key", newJString(key))
  add(query_580519, "prettyPrint", newJBool(prettyPrint))
  result = call_580518.call(nil, query_580519, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_580507(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_580508, base: "/adsense/v1.4",
    url: url_AdsenseMetadataMetricsList_580509, schemes: {Scheme.Https})
type
  Call_AdsensePaymentsList_580520 = ref object of OpenApiRestCall_579424
proc url_AdsensePaymentsList_580522(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensePaymentsList_580521(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List the payments for this AdSense account.
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
  var valid_580523 = query.getOrDefault("fields")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "fields", valid_580523
  var valid_580524 = query.getOrDefault("quotaUser")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "quotaUser", valid_580524
  var valid_580525 = query.getOrDefault("alt")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = newJString("json"))
  if valid_580525 != nil:
    section.add "alt", valid_580525
  var valid_580526 = query.getOrDefault("oauth_token")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "oauth_token", valid_580526
  var valid_580527 = query.getOrDefault("userIp")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "userIp", valid_580527
  var valid_580528 = query.getOrDefault("key")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "key", valid_580528
  var valid_580529 = query.getOrDefault("prettyPrint")
  valid_580529 = validateParameter(valid_580529, JBool, required = false,
                                 default = newJBool(true))
  if valid_580529 != nil:
    section.add "prettyPrint", valid_580529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580530: Call_AdsensePaymentsList_580520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the payments for this AdSense account.
  ## 
  let valid = call_580530.validator(path, query, header, formData, body)
  let scheme = call_580530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580530.url(scheme.get, call_580530.host, call_580530.base,
                         call_580530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580530, url, valid)

proc call*(call_580531: Call_AdsensePaymentsList_580520; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsensePaymentsList
  ## List the payments for this AdSense account.
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
  var query_580532 = newJObject()
  add(query_580532, "fields", newJString(fields))
  add(query_580532, "quotaUser", newJString(quotaUser))
  add(query_580532, "alt", newJString(alt))
  add(query_580532, "oauth_token", newJString(oauthToken))
  add(query_580532, "userIp", newJString(userIp))
  add(query_580532, "key", newJString(key))
  add(query_580532, "prettyPrint", newJBool(prettyPrint))
  result = call_580531.call(nil, query_580532, nil, nil, nil)

var adsensePaymentsList* = Call_AdsensePaymentsList_580520(
    name: "adsensePaymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/payments",
    validator: validate_AdsensePaymentsList_580521, base: "/adsense/v1.4",
    url: url_AdsensePaymentsList_580522, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_580533 = ref object of OpenApiRestCall_579424
proc url_AdsenseReportsGenerate_580535(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_580534(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
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
  ##   currency: JString
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   accountId: JArray
  ##            : Accounts upon which to report.
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
  var valid_580536 = query.getOrDefault("useTimezoneReporting")
  valid_580536 = validateParameter(valid_580536, JBool, required = false, default = nil)
  if valid_580536 != nil:
    section.add "useTimezoneReporting", valid_580536
  var valid_580537 = query.getOrDefault("locale")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "locale", valid_580537
  var valid_580538 = query.getOrDefault("fields")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "fields", valid_580538
  var valid_580539 = query.getOrDefault("quotaUser")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "quotaUser", valid_580539
  var valid_580540 = query.getOrDefault("alt")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = newJString("json"))
  if valid_580540 != nil:
    section.add "alt", valid_580540
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_580541 = query.getOrDefault("endDate")
  valid_580541 = validateParameter(valid_580541, JString, required = true,
                                 default = nil)
  if valid_580541 != nil:
    section.add "endDate", valid_580541
  var valid_580542 = query.getOrDefault("currency")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "currency", valid_580542
  var valid_580543 = query.getOrDefault("startDate")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "startDate", valid_580543
  var valid_580544 = query.getOrDefault("sort")
  valid_580544 = validateParameter(valid_580544, JArray, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "sort", valid_580544
  var valid_580545 = query.getOrDefault("oauth_token")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "oauth_token", valid_580545
  var valid_580546 = query.getOrDefault("accountId")
  valid_580546 = validateParameter(valid_580546, JArray, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "accountId", valid_580546
  var valid_580547 = query.getOrDefault("userIp")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "userIp", valid_580547
  var valid_580548 = query.getOrDefault("maxResults")
  valid_580548 = validateParameter(valid_580548, JInt, required = false, default = nil)
  if valid_580548 != nil:
    section.add "maxResults", valid_580548
  var valid_580549 = query.getOrDefault("key")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "key", valid_580549
  var valid_580550 = query.getOrDefault("metric")
  valid_580550 = validateParameter(valid_580550, JArray, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "metric", valid_580550
  var valid_580551 = query.getOrDefault("prettyPrint")
  valid_580551 = validateParameter(valid_580551, JBool, required = false,
                                 default = newJBool(true))
  if valid_580551 != nil:
    section.add "prettyPrint", valid_580551
  var valid_580552 = query.getOrDefault("dimension")
  valid_580552 = validateParameter(valid_580552, JArray, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "dimension", valid_580552
  var valid_580553 = query.getOrDefault("filter")
  valid_580553 = validateParameter(valid_580553, JArray, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "filter", valid_580553
  var valid_580554 = query.getOrDefault("startIndex")
  valid_580554 = validateParameter(valid_580554, JInt, required = false, default = nil)
  if valid_580554 != nil:
    section.add "startIndex", valid_580554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580555: Call_AdsenseReportsGenerate_580533; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_580555.validator(path, query, header, formData, body)
  let scheme = call_580555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580555.url(scheme.get, call_580555.host, call_580555.base,
                         call_580555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580555, url, valid)

proc call*(call_580556: Call_AdsenseReportsGenerate_580533; endDate: string;
          startDate: string; useTimezoneReporting: bool = false; locale: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          currency: string = ""; sort: JsonNode = nil; oauthToken: string = "";
          accountId: JsonNode = nil; userIp: string = ""; maxResults: int = 0;
          key: string = ""; metric: JsonNode = nil; prettyPrint: bool = true;
          dimension: JsonNode = nil; filter: JsonNode = nil; startIndex: int = 0): Recallable =
  ## adsenseReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   useTimezoneReporting: bool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
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
  ##   currency: string
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: JArray
  ##            : Accounts upon which to report.
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
  var query_580557 = newJObject()
  add(query_580557, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_580557, "locale", newJString(locale))
  add(query_580557, "fields", newJString(fields))
  add(query_580557, "quotaUser", newJString(quotaUser))
  add(query_580557, "alt", newJString(alt))
  add(query_580557, "endDate", newJString(endDate))
  add(query_580557, "currency", newJString(currency))
  add(query_580557, "startDate", newJString(startDate))
  if sort != nil:
    query_580557.add "sort", sort
  add(query_580557, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_580557.add "accountId", accountId
  add(query_580557, "userIp", newJString(userIp))
  add(query_580557, "maxResults", newJInt(maxResults))
  add(query_580557, "key", newJString(key))
  if metric != nil:
    query_580557.add "metric", metric
  add(query_580557, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_580557.add "dimension", dimension
  if filter != nil:
    query_580557.add "filter", filter
  add(query_580557, "startIndex", newJInt(startIndex))
  result = call_580556.call(nil, query_580557, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_580533(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_580534, base: "/adsense/v1.4",
    url: url_AdsenseReportsGenerate_580535, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_580558 = ref object of OpenApiRestCall_579424
proc url_AdsenseReportsSavedList_580560(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_580559(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this AdSense account.
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
  var valid_580561 = query.getOrDefault("fields")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "fields", valid_580561
  var valid_580562 = query.getOrDefault("pageToken")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "pageToken", valid_580562
  var valid_580563 = query.getOrDefault("quotaUser")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "quotaUser", valid_580563
  var valid_580564 = query.getOrDefault("alt")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = newJString("json"))
  if valid_580564 != nil:
    section.add "alt", valid_580564
  var valid_580565 = query.getOrDefault("oauth_token")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "oauth_token", valid_580565
  var valid_580566 = query.getOrDefault("userIp")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "userIp", valid_580566
  var valid_580567 = query.getOrDefault("maxResults")
  valid_580567 = validateParameter(valid_580567, JInt, required = false, default = nil)
  if valid_580567 != nil:
    section.add "maxResults", valid_580567
  var valid_580568 = query.getOrDefault("key")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "key", valid_580568
  var valid_580569 = query.getOrDefault("prettyPrint")
  valid_580569 = validateParameter(valid_580569, JBool, required = false,
                                 default = newJBool(true))
  if valid_580569 != nil:
    section.add "prettyPrint", valid_580569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580570: Call_AdsenseReportsSavedList_580558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_580570.validator(path, query, header, formData, body)
  let scheme = call_580570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580570.url(scheme.get, call_580570.host, call_580570.base,
                         call_580570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580570, url, valid)

proc call*(call_580571: Call_AdsenseReportsSavedList_580558; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseReportsSavedList
  ## List all saved reports in this AdSense account.
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
  var query_580572 = newJObject()
  add(query_580572, "fields", newJString(fields))
  add(query_580572, "pageToken", newJString(pageToken))
  add(query_580572, "quotaUser", newJString(quotaUser))
  add(query_580572, "alt", newJString(alt))
  add(query_580572, "oauth_token", newJString(oauthToken))
  add(query_580572, "userIp", newJString(userIp))
  add(query_580572, "maxResults", newJInt(maxResults))
  add(query_580572, "key", newJString(key))
  add(query_580572, "prettyPrint", newJBool(prettyPrint))
  result = call_580571.call(nil, query_580572, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_580558(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_580559, base: "/adsense/v1.4",
    url: url_AdsenseReportsSavedList_580560, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_580573 = ref object of OpenApiRestCall_579424
proc url_AdsenseReportsSavedGenerate_580575(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseReportsSavedGenerate_580574(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedReportId` field"
  var valid_580576 = path.getOrDefault("savedReportId")
  valid_580576 = validateParameter(valid_580576, JString, required = true,
                                 default = nil)
  if valid_580576 != nil:
    section.add "savedReportId", valid_580576
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
  var valid_580577 = query.getOrDefault("locale")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "locale", valid_580577
  var valid_580578 = query.getOrDefault("fields")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "fields", valid_580578
  var valid_580579 = query.getOrDefault("quotaUser")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "quotaUser", valid_580579
  var valid_580580 = query.getOrDefault("alt")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = newJString("json"))
  if valid_580580 != nil:
    section.add "alt", valid_580580
  var valid_580581 = query.getOrDefault("oauth_token")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "oauth_token", valid_580581
  var valid_580582 = query.getOrDefault("userIp")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "userIp", valid_580582
  var valid_580583 = query.getOrDefault("maxResults")
  valid_580583 = validateParameter(valid_580583, JInt, required = false, default = nil)
  if valid_580583 != nil:
    section.add "maxResults", valid_580583
  var valid_580584 = query.getOrDefault("key")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "key", valid_580584
  var valid_580585 = query.getOrDefault("prettyPrint")
  valid_580585 = validateParameter(valid_580585, JBool, required = false,
                                 default = newJBool(true))
  if valid_580585 != nil:
    section.add "prettyPrint", valid_580585
  var valid_580586 = query.getOrDefault("startIndex")
  valid_580586 = validateParameter(valid_580586, JInt, required = false, default = nil)
  if valid_580586 != nil:
    section.add "startIndex", valid_580586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580587: Call_AdsenseReportsSavedGenerate_580573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_580587.validator(path, query, header, formData, body)
  let scheme = call_580587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580587.url(scheme.get, call_580587.host, call_580587.base,
                         call_580587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580587, url, valid)

proc call*(call_580588: Call_AdsenseReportsSavedGenerate_580573;
          savedReportId: string; locale: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## adsenseReportsSavedGenerate
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
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
  var path_580589 = newJObject()
  var query_580590 = newJObject()
  add(query_580590, "locale", newJString(locale))
  add(query_580590, "fields", newJString(fields))
  add(query_580590, "quotaUser", newJString(quotaUser))
  add(query_580590, "alt", newJString(alt))
  add(query_580590, "oauth_token", newJString(oauthToken))
  add(query_580590, "userIp", newJString(userIp))
  add(query_580590, "maxResults", newJInt(maxResults))
  add(path_580589, "savedReportId", newJString(savedReportId))
  add(query_580590, "key", newJString(key))
  add(query_580590, "prettyPrint", newJBool(prettyPrint))
  add(query_580590, "startIndex", newJInt(startIndex))
  result = call_580588.call(path_580589, query_580590, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_580573(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_580574, base: "/adsense/v1.4",
    url: url_AdsenseReportsSavedGenerate_580575, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_580591 = ref object of OpenApiRestCall_579424
proc url_AdsenseSavedadstylesList_580593(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_580592(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved ad styles in the user's account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580594 = query.getOrDefault("fields")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "fields", valid_580594
  var valid_580595 = query.getOrDefault("pageToken")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "pageToken", valid_580595
  var valid_580596 = query.getOrDefault("quotaUser")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "quotaUser", valid_580596
  var valid_580597 = query.getOrDefault("alt")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = newJString("json"))
  if valid_580597 != nil:
    section.add "alt", valid_580597
  var valid_580598 = query.getOrDefault("oauth_token")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "oauth_token", valid_580598
  var valid_580599 = query.getOrDefault("userIp")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "userIp", valid_580599
  var valid_580600 = query.getOrDefault("maxResults")
  valid_580600 = validateParameter(valid_580600, JInt, required = false, default = nil)
  if valid_580600 != nil:
    section.add "maxResults", valid_580600
  var valid_580601 = query.getOrDefault("key")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "key", valid_580601
  var valid_580602 = query.getOrDefault("prettyPrint")
  valid_580602 = validateParameter(valid_580602, JBool, required = false,
                                 default = newJBool(true))
  if valid_580602 != nil:
    section.add "prettyPrint", valid_580602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580603: Call_AdsenseSavedadstylesList_580591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_580603.validator(path, query, header, formData, body)
  let scheme = call_580603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580603.url(scheme.get, call_580603.host, call_580603.base,
                         call_580603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580603, url, valid)

proc call*(call_580604: Call_AdsenseSavedadstylesList_580591; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseSavedadstylesList
  ## List all saved ad styles in the user's account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580605 = newJObject()
  add(query_580605, "fields", newJString(fields))
  add(query_580605, "pageToken", newJString(pageToken))
  add(query_580605, "quotaUser", newJString(quotaUser))
  add(query_580605, "alt", newJString(alt))
  add(query_580605, "oauth_token", newJString(oauthToken))
  add(query_580605, "userIp", newJString(userIp))
  add(query_580605, "maxResults", newJInt(maxResults))
  add(query_580605, "key", newJString(key))
  add(query_580605, "prettyPrint", newJBool(prettyPrint))
  result = call_580604.call(nil, query_580605, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_580591(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_580592, base: "/adsense/v1.4",
    url: url_AdsenseSavedadstylesList_580593, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_580606 = ref object of OpenApiRestCall_579424
proc url_AdsenseSavedadstylesGet_580608(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedAdStyleId" in path, "`savedAdStyleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/savedadstyles/"),
               (kind: VariableSegment, value: "savedAdStyleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseSavedadstylesGet_580607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific saved ad style from the user's account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedAdStyleId: JString (required)
  ##                 : Saved ad style to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedAdStyleId` field"
  var valid_580609 = path.getOrDefault("savedAdStyleId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = nil)
  if valid_580609 != nil:
    section.add "savedAdStyleId", valid_580609
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
  var valid_580610 = query.getOrDefault("fields")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "fields", valid_580610
  var valid_580611 = query.getOrDefault("quotaUser")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "quotaUser", valid_580611
  var valid_580612 = query.getOrDefault("alt")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = newJString("json"))
  if valid_580612 != nil:
    section.add "alt", valid_580612
  var valid_580613 = query.getOrDefault("oauth_token")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "oauth_token", valid_580613
  var valid_580614 = query.getOrDefault("userIp")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "userIp", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("prettyPrint")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(true))
  if valid_580616 != nil:
    section.add "prettyPrint", valid_580616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580617: Call_AdsenseSavedadstylesGet_580606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_580617.validator(path, query, header, formData, body)
  let scheme = call_580617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580617.url(scheme.get, call_580617.host, call_580617.base,
                         call_580617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580617, url, valid)

proc call*(call_580618: Call_AdsenseSavedadstylesGet_580606;
          savedAdStyleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseSavedadstylesGet
  ## Get a specific saved ad style from the user's account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580619 = newJObject()
  var query_580620 = newJObject()
  add(query_580620, "fields", newJString(fields))
  add(query_580620, "quotaUser", newJString(quotaUser))
  add(query_580620, "alt", newJString(alt))
  add(query_580620, "oauth_token", newJString(oauthToken))
  add(path_580619, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_580620, "userIp", newJString(userIp))
  add(query_580620, "key", newJString(key))
  add(query_580620, "prettyPrint", newJBool(prettyPrint))
  result = call_580618.call(path_580619, query_580620, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_580606(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_580607, base: "/adsense/v1.4",
    url: url_AdsenseSavedadstylesGet_580608, schemes: {Scheme.Https})
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
