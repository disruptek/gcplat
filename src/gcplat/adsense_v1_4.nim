
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "adsense"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsenseAccountsList_597693 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsList_597695(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseAccountsList_597694(path: JsonNode; query: JsonNode;
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

proc call*(call_597851: Call_AdsenseAccountsList_597693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this AdSense account.
  ## 
  let valid = call_597851.validator(path, query, header, formData, body)
  let scheme = call_597851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597851.url(scheme.get, call_597851.host, call_597851.base,
                         call_597851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597851, url, valid)

proc call*(call_597922: Call_AdsenseAccountsList_597693; fields: string = "";
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

var adsenseAccountsList* = Call_AdsenseAccountsList_597693(
    name: "adsenseAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsenseAccountsList_597694, base: "/adsense/v1.4",
    url: url_AdsenseAccountsList_597695, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsGet_597963 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsGet_597965(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsGet_597964(path: JsonNode; query: JsonNode;
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
  ##   tree: JBool
  ##       : Whether the tree of sub accounts should be returned.
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
  var valid_597987 = query.getOrDefault("tree")
  valid_597987 = validateParameter(valid_597987, JBool, required = false, default = nil)
  if valid_597987 != nil:
    section.add "tree", valid_597987
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

proc call*(call_597989: Call_AdsenseAccountsGet_597963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected AdSense account.
  ## 
  let valid = call_597989.validator(path, query, header, formData, body)
  let scheme = call_597989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597989.url(scheme.get, call_597989.host, call_597989.base,
                         call_597989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597989, url, valid)

proc call*(call_597990: Call_AdsenseAccountsGet_597963; accountId: string;
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
  var path_597991 = newJObject()
  var query_597992 = newJObject()
  add(query_597992, "fields", newJString(fields))
  add(query_597992, "quotaUser", newJString(quotaUser))
  add(query_597992, "alt", newJString(alt))
  add(query_597992, "oauth_token", newJString(oauthToken))
  add(path_597991, "accountId", newJString(accountId))
  add(query_597992, "userIp", newJString(userIp))
  add(query_597992, "key", newJString(key))
  add(query_597992, "tree", newJBool(tree))
  add(query_597992, "prettyPrint", newJBool(prettyPrint))
  result = call_597990.call(path_597991, query_597992, nil, nil, nil)

var adsenseAccountsGet* = Call_AdsenseAccountsGet_597963(
    name: "adsenseAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsenseAccountsGet_597964, base: "/adsense/v1.4",
    url: url_AdsenseAccountsGet_597965, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsList_597993 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdclientsList_597995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsAdclientsList_597994(path: JsonNode; query: JsonNode;
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
  var valid_597996 = path.getOrDefault("accountId")
  valid_597996 = validateParameter(valid_597996, JString, required = true,
                                 default = nil)
  if valid_597996 != nil:
    section.add "accountId", valid_597996
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
  var valid_597997 = query.getOrDefault("fields")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "fields", valid_597997
  var valid_597998 = query.getOrDefault("pageToken")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "pageToken", valid_597998
  var valid_597999 = query.getOrDefault("quotaUser")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "quotaUser", valid_597999
  var valid_598000 = query.getOrDefault("alt")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = newJString("json"))
  if valid_598000 != nil:
    section.add "alt", valid_598000
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

proc call*(call_598006: Call_AdsenseAccountsAdclientsList_597993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in the specified account.
  ## 
  let valid = call_598006.validator(path, query, header, formData, body)
  let scheme = call_598006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598006.url(scheme.get, call_598006.host, call_598006.base,
                         call_598006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598006, url, valid)

proc call*(call_598007: Call_AdsenseAccountsAdclientsList_597993;
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
  var path_598008 = newJObject()
  var query_598009 = newJObject()
  add(query_598009, "fields", newJString(fields))
  add(query_598009, "pageToken", newJString(pageToken))
  add(query_598009, "quotaUser", newJString(quotaUser))
  add(query_598009, "alt", newJString(alt))
  add(query_598009, "oauth_token", newJString(oauthToken))
  add(path_598008, "accountId", newJString(accountId))
  add(query_598009, "userIp", newJString(userIp))
  add(query_598009, "maxResults", newJInt(maxResults))
  add(query_598009, "key", newJString(key))
  add(query_598009, "prettyPrint", newJBool(prettyPrint))
  result = call_598007.call(path_598008, query_598009, nil, nil, nil)

var adsenseAccountsAdclientsList* = Call_AdsenseAccountsAdclientsList_597993(
    name: "adsenseAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsenseAccountsAdclientsList_597994,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdclientsList_597995,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsGetAdCode_598010 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdclientsGetAdCode_598012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdclientsGetAdCode_598011(path: JsonNode;
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
  var valid_598013 = path.getOrDefault("accountId")
  valid_598013 = validateParameter(valid_598013, JString, required = true,
                                 default = nil)
  if valid_598013 != nil:
    section.add "accountId", valid_598013
  var valid_598014 = path.getOrDefault("adClientId")
  valid_598014 = validateParameter(valid_598014, JString, required = true,
                                 default = nil)
  if valid_598014 != nil:
    section.add "adClientId", valid_598014
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

proc call*(call_598022: Call_AdsenseAccountsAdclientsGetAdCode_598010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Auto ad code for a given ad client.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_AdsenseAccountsAdclientsGetAdCode_598010;
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
  var path_598024 = newJObject()
  var query_598025 = newJObject()
  add(query_598025, "fields", newJString(fields))
  add(query_598025, "quotaUser", newJString(quotaUser))
  add(query_598025, "alt", newJString(alt))
  add(query_598025, "oauth_token", newJString(oauthToken))
  add(path_598024, "accountId", newJString(accountId))
  add(query_598025, "userIp", newJString(userIp))
  add(query_598025, "key", newJString(key))
  add(path_598024, "adClientId", newJString(adClientId))
  add(query_598025, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(path_598024, query_598025, nil, nil, nil)

var adsenseAccountsAdclientsGetAdCode* = Call_AdsenseAccountsAdclientsGetAdCode_598010(
    name: "adsenseAccountsAdclientsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adcode",
    validator: validate_AdsenseAccountsAdclientsGetAdCode_598011,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdclientsGetAdCode_598012,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_598026 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsList_598028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsAdunitsList_598027(path: JsonNode; query: JsonNode;
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
  var valid_598029 = path.getOrDefault("accountId")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "accountId", valid_598029
  var valid_598030 = path.getOrDefault("adClientId")
  valid_598030 = validateParameter(valid_598030, JString, required = true,
                                 default = nil)
  if valid_598030 != nil:
    section.add "adClientId", valid_598030
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
  var valid_598035 = query.getOrDefault("includeInactive")
  valid_598035 = validateParameter(valid_598035, JBool, required = false, default = nil)
  if valid_598035 != nil:
    section.add "includeInactive", valid_598035
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
  var valid_598038 = query.getOrDefault("maxResults")
  valid_598038 = validateParameter(valid_598038, JInt, required = false, default = nil)
  if valid_598038 != nil:
    section.add "maxResults", valid_598038
  var valid_598039 = query.getOrDefault("key")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "key", valid_598039
  var valid_598040 = query.getOrDefault("prettyPrint")
  valid_598040 = validateParameter(valid_598040, JBool, required = false,
                                 default = newJBool(true))
  if valid_598040 != nil:
    section.add "prettyPrint", valid_598040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598041: Call_AdsenseAccountsAdunitsList_598026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_AdsenseAccountsAdunitsList_598026; accountId: string;
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
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "pageToken", newJString(pageToken))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "includeInactive", newJBool(includeInactive))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(path_598043, "accountId", newJString(accountId))
  add(query_598044, "userIp", newJString(userIp))
  add(query_598044, "maxResults", newJInt(maxResults))
  add(query_598044, "key", newJString(key))
  add(path_598043, "adClientId", newJString(adClientId))
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  result = call_598042.call(path_598043, query_598044, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_598026(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_598027, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAdunitsList_598028, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_598045 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsGet_598047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsAdunitsGet_598046(path: JsonNode; query: JsonNode;
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
  var valid_598048 = path.getOrDefault("accountId")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "accountId", valid_598048
  var valid_598049 = path.getOrDefault("adClientId")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "adClientId", valid_598049
  var valid_598050 = path.getOrDefault("adUnitId")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "adUnitId", valid_598050
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
  var valid_598051 = query.getOrDefault("fields")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "fields", valid_598051
  var valid_598052 = query.getOrDefault("quotaUser")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "quotaUser", valid_598052
  var valid_598053 = query.getOrDefault("alt")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = newJString("json"))
  if valid_598053 != nil:
    section.add "alt", valid_598053
  var valid_598054 = query.getOrDefault("oauth_token")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "oauth_token", valid_598054
  var valid_598055 = query.getOrDefault("userIp")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "userIp", valid_598055
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

proc call*(call_598058: Call_AdsenseAccountsAdunitsGet_598045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_598058.validator(path, query, header, formData, body)
  let scheme = call_598058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598058.url(scheme.get, call_598058.host, call_598058.base,
                         call_598058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598058, url, valid)

proc call*(call_598059: Call_AdsenseAccountsAdunitsGet_598045; accountId: string;
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
  var path_598060 = newJObject()
  var query_598061 = newJObject()
  add(query_598061, "fields", newJString(fields))
  add(query_598061, "quotaUser", newJString(quotaUser))
  add(query_598061, "alt", newJString(alt))
  add(query_598061, "oauth_token", newJString(oauthToken))
  add(path_598060, "accountId", newJString(accountId))
  add(query_598061, "userIp", newJString(userIp))
  add(query_598061, "key", newJString(key))
  add(path_598060, "adClientId", newJString(adClientId))
  add(path_598060, "adUnitId", newJString(adUnitId))
  add(query_598061, "prettyPrint", newJBool(prettyPrint))
  result = call_598059.call(path_598060, query_598061, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_598045(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_598046, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAdunitsGet_598047, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_598062 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsGetAdCode_598064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsAdunitsGetAdCode_598063(path: JsonNode;
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
  var valid_598065 = path.getOrDefault("accountId")
  valid_598065 = validateParameter(valid_598065, JString, required = true,
                                 default = nil)
  if valid_598065 != nil:
    section.add "accountId", valid_598065
  var valid_598066 = path.getOrDefault("adClientId")
  valid_598066 = validateParameter(valid_598066, JString, required = true,
                                 default = nil)
  if valid_598066 != nil:
    section.add "adClientId", valid_598066
  var valid_598067 = path.getOrDefault("adUnitId")
  valid_598067 = validateParameter(valid_598067, JString, required = true,
                                 default = nil)
  if valid_598067 != nil:
    section.add "adUnitId", valid_598067
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
  var valid_598068 = query.getOrDefault("fields")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "fields", valid_598068
  var valid_598069 = query.getOrDefault("quotaUser")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "quotaUser", valid_598069
  var valid_598070 = query.getOrDefault("alt")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = newJString("json"))
  if valid_598070 != nil:
    section.add "alt", valid_598070
  var valid_598071 = query.getOrDefault("oauth_token")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "oauth_token", valid_598071
  var valid_598072 = query.getOrDefault("userIp")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "userIp", valid_598072
  var valid_598073 = query.getOrDefault("key")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "key", valid_598073
  var valid_598074 = query.getOrDefault("prettyPrint")
  valid_598074 = validateParameter(valid_598074, JBool, required = false,
                                 default = newJBool(true))
  if valid_598074 != nil:
    section.add "prettyPrint", valid_598074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598075: Call_AdsenseAccountsAdunitsGetAdCode_598062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_598075.validator(path, query, header, formData, body)
  let scheme = call_598075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598075.url(scheme.get, call_598075.host, call_598075.base,
                         call_598075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598075, url, valid)

proc call*(call_598076: Call_AdsenseAccountsAdunitsGetAdCode_598062;
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
  var path_598077 = newJObject()
  var query_598078 = newJObject()
  add(query_598078, "fields", newJString(fields))
  add(query_598078, "quotaUser", newJString(quotaUser))
  add(query_598078, "alt", newJString(alt))
  add(query_598078, "oauth_token", newJString(oauthToken))
  add(path_598077, "accountId", newJString(accountId))
  add(query_598078, "userIp", newJString(userIp))
  add(query_598078, "key", newJString(key))
  add(path_598077, "adClientId", newJString(adClientId))
  add(path_598077, "adUnitId", newJString(adUnitId))
  add(query_598078, "prettyPrint", newJBool(prettyPrint))
  result = call_598076.call(path_598077, query_598078, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_598062(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_598063,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdunitsGetAdCode_598064,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_598079 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsCustomchannelsList_598081(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsAdunitsCustomchannelsList_598080(path: JsonNode;
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
  var valid_598082 = path.getOrDefault("accountId")
  valid_598082 = validateParameter(valid_598082, JString, required = true,
                                 default = nil)
  if valid_598082 != nil:
    section.add "accountId", valid_598082
  var valid_598083 = path.getOrDefault("adClientId")
  valid_598083 = validateParameter(valid_598083, JString, required = true,
                                 default = nil)
  if valid_598083 != nil:
    section.add "adClientId", valid_598083
  var valid_598084 = path.getOrDefault("adUnitId")
  valid_598084 = validateParameter(valid_598084, JString, required = true,
                                 default = nil)
  if valid_598084 != nil:
    section.add "adUnitId", valid_598084
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
  var valid_598085 = query.getOrDefault("fields")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "fields", valid_598085
  var valid_598086 = query.getOrDefault("pageToken")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "pageToken", valid_598086
  var valid_598087 = query.getOrDefault("quotaUser")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "quotaUser", valid_598087
  var valid_598088 = query.getOrDefault("alt")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = newJString("json"))
  if valid_598088 != nil:
    section.add "alt", valid_598088
  var valid_598089 = query.getOrDefault("oauth_token")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "oauth_token", valid_598089
  var valid_598090 = query.getOrDefault("userIp")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = nil)
  if valid_598090 != nil:
    section.add "userIp", valid_598090
  var valid_598091 = query.getOrDefault("maxResults")
  valid_598091 = validateParameter(valid_598091, JInt, required = false, default = nil)
  if valid_598091 != nil:
    section.add "maxResults", valid_598091
  var valid_598092 = query.getOrDefault("key")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "key", valid_598092
  var valid_598093 = query.getOrDefault("prettyPrint")
  valid_598093 = validateParameter(valid_598093, JBool, required = false,
                                 default = newJBool(true))
  if valid_598093 != nil:
    section.add "prettyPrint", valid_598093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598094: Call_AdsenseAccountsAdunitsCustomchannelsList_598079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_598094.validator(path, query, header, formData, body)
  let scheme = call_598094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598094.url(scheme.get, call_598094.host, call_598094.base,
                         call_598094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598094, url, valid)

proc call*(call_598095: Call_AdsenseAccountsAdunitsCustomchannelsList_598079;
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
  var path_598096 = newJObject()
  var query_598097 = newJObject()
  add(query_598097, "fields", newJString(fields))
  add(query_598097, "pageToken", newJString(pageToken))
  add(query_598097, "quotaUser", newJString(quotaUser))
  add(query_598097, "alt", newJString(alt))
  add(query_598097, "oauth_token", newJString(oauthToken))
  add(path_598096, "accountId", newJString(accountId))
  add(query_598097, "userIp", newJString(userIp))
  add(query_598097, "maxResults", newJInt(maxResults))
  add(query_598097, "key", newJString(key))
  add(path_598096, "adClientId", newJString(adClientId))
  add(path_598096, "adUnitId", newJString(adUnitId))
  add(query_598097, "prettyPrint", newJBool(prettyPrint))
  result = call_598095.call(path_598096, query_598097, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_598079(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_598080,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdunitsCustomchannelsList_598081,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_598098 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsCustomchannelsList_598100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsCustomchannelsList_598099(path: JsonNode;
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
  var valid_598101 = path.getOrDefault("accountId")
  valid_598101 = validateParameter(valid_598101, JString, required = true,
                                 default = nil)
  if valid_598101 != nil:
    section.add "accountId", valid_598101
  var valid_598102 = path.getOrDefault("adClientId")
  valid_598102 = validateParameter(valid_598102, JString, required = true,
                                 default = nil)
  if valid_598102 != nil:
    section.add "adClientId", valid_598102
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
  var valid_598103 = query.getOrDefault("fields")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "fields", valid_598103
  var valid_598104 = query.getOrDefault("pageToken")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "pageToken", valid_598104
  var valid_598105 = query.getOrDefault("quotaUser")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "quotaUser", valid_598105
  var valid_598106 = query.getOrDefault("alt")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = newJString("json"))
  if valid_598106 != nil:
    section.add "alt", valid_598106
  var valid_598107 = query.getOrDefault("oauth_token")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "oauth_token", valid_598107
  var valid_598108 = query.getOrDefault("userIp")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "userIp", valid_598108
  var valid_598109 = query.getOrDefault("maxResults")
  valid_598109 = validateParameter(valid_598109, JInt, required = false, default = nil)
  if valid_598109 != nil:
    section.add "maxResults", valid_598109
  var valid_598110 = query.getOrDefault("key")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "key", valid_598110
  var valid_598111 = query.getOrDefault("prettyPrint")
  valid_598111 = validateParameter(valid_598111, JBool, required = false,
                                 default = newJBool(true))
  if valid_598111 != nil:
    section.add "prettyPrint", valid_598111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598112: Call_AdsenseAccountsCustomchannelsList_598098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_598112.validator(path, query, header, formData, body)
  let scheme = call_598112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598112.url(scheme.get, call_598112.host, call_598112.base,
                         call_598112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598112, url, valid)

proc call*(call_598113: Call_AdsenseAccountsCustomchannelsList_598098;
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
  var path_598114 = newJObject()
  var query_598115 = newJObject()
  add(query_598115, "fields", newJString(fields))
  add(query_598115, "pageToken", newJString(pageToken))
  add(query_598115, "quotaUser", newJString(quotaUser))
  add(query_598115, "alt", newJString(alt))
  add(query_598115, "oauth_token", newJString(oauthToken))
  add(path_598114, "accountId", newJString(accountId))
  add(query_598115, "userIp", newJString(userIp))
  add(query_598115, "maxResults", newJInt(maxResults))
  add(query_598115, "key", newJString(key))
  add(path_598114, "adClientId", newJString(adClientId))
  add(query_598115, "prettyPrint", newJBool(prettyPrint))
  result = call_598113.call(path_598114, query_598115, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_598098(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_598099,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsList_598100,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_598116 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsCustomchannelsGet_598118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsCustomchannelsGet_598117(path: JsonNode;
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
  var valid_598119 = path.getOrDefault("accountId")
  valid_598119 = validateParameter(valid_598119, JString, required = true,
                                 default = nil)
  if valid_598119 != nil:
    section.add "accountId", valid_598119
  var valid_598120 = path.getOrDefault("customChannelId")
  valid_598120 = validateParameter(valid_598120, JString, required = true,
                                 default = nil)
  if valid_598120 != nil:
    section.add "customChannelId", valid_598120
  var valid_598121 = path.getOrDefault("adClientId")
  valid_598121 = validateParameter(valid_598121, JString, required = true,
                                 default = nil)
  if valid_598121 != nil:
    section.add "adClientId", valid_598121
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
  var valid_598122 = query.getOrDefault("fields")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "fields", valid_598122
  var valid_598123 = query.getOrDefault("quotaUser")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "quotaUser", valid_598123
  var valid_598124 = query.getOrDefault("alt")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = newJString("json"))
  if valid_598124 != nil:
    section.add "alt", valid_598124
  var valid_598125 = query.getOrDefault("oauth_token")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "oauth_token", valid_598125
  var valid_598126 = query.getOrDefault("userIp")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "userIp", valid_598126
  var valid_598127 = query.getOrDefault("key")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "key", valid_598127
  var valid_598128 = query.getOrDefault("prettyPrint")
  valid_598128 = validateParameter(valid_598128, JBool, required = false,
                                 default = newJBool(true))
  if valid_598128 != nil:
    section.add "prettyPrint", valid_598128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598129: Call_AdsenseAccountsCustomchannelsGet_598116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_598129.validator(path, query, header, formData, body)
  let scheme = call_598129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598129.url(scheme.get, call_598129.host, call_598129.base,
                         call_598129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598129, url, valid)

proc call*(call_598130: Call_AdsenseAccountsCustomchannelsGet_598116;
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
  var path_598131 = newJObject()
  var query_598132 = newJObject()
  add(query_598132, "fields", newJString(fields))
  add(query_598132, "quotaUser", newJString(quotaUser))
  add(query_598132, "alt", newJString(alt))
  add(query_598132, "oauth_token", newJString(oauthToken))
  add(path_598131, "accountId", newJString(accountId))
  add(path_598131, "customChannelId", newJString(customChannelId))
  add(query_598132, "userIp", newJString(userIp))
  add(query_598132, "key", newJString(key))
  add(path_598131, "adClientId", newJString(adClientId))
  add(query_598132, "prettyPrint", newJBool(prettyPrint))
  result = call_598130.call(path_598131, query_598132, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_598116(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_598117,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsGet_598118,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_598133 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsCustomchannelsAdunitsList_598135(protocol: Scheme;
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
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAccountsCustomchannelsAdunitsList_598134(path: JsonNode;
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
  var valid_598136 = path.getOrDefault("accountId")
  valid_598136 = validateParameter(valid_598136, JString, required = true,
                                 default = nil)
  if valid_598136 != nil:
    section.add "accountId", valid_598136
  var valid_598137 = path.getOrDefault("customChannelId")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "customChannelId", valid_598137
  var valid_598138 = path.getOrDefault("adClientId")
  valid_598138 = validateParameter(valid_598138, JString, required = true,
                                 default = nil)
  if valid_598138 != nil:
    section.add "adClientId", valid_598138
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
  var valid_598139 = query.getOrDefault("fields")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "fields", valid_598139
  var valid_598140 = query.getOrDefault("pageToken")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "pageToken", valid_598140
  var valid_598141 = query.getOrDefault("quotaUser")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "quotaUser", valid_598141
  var valid_598142 = query.getOrDefault("alt")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = newJString("json"))
  if valid_598142 != nil:
    section.add "alt", valid_598142
  var valid_598143 = query.getOrDefault("includeInactive")
  valid_598143 = validateParameter(valid_598143, JBool, required = false, default = nil)
  if valid_598143 != nil:
    section.add "includeInactive", valid_598143
  var valid_598144 = query.getOrDefault("oauth_token")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "oauth_token", valid_598144
  var valid_598145 = query.getOrDefault("userIp")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "userIp", valid_598145
  var valid_598146 = query.getOrDefault("maxResults")
  valid_598146 = validateParameter(valid_598146, JInt, required = false, default = nil)
  if valid_598146 != nil:
    section.add "maxResults", valid_598146
  var valid_598147 = query.getOrDefault("key")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "key", valid_598147
  var valid_598148 = query.getOrDefault("prettyPrint")
  valid_598148 = validateParameter(valid_598148, JBool, required = false,
                                 default = newJBool(true))
  if valid_598148 != nil:
    section.add "prettyPrint", valid_598148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598149: Call_AdsenseAccountsCustomchannelsAdunitsList_598133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_598149.validator(path, query, header, formData, body)
  let scheme = call_598149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598149.url(scheme.get, call_598149.host, call_598149.base,
                         call_598149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598149, url, valid)

proc call*(call_598150: Call_AdsenseAccountsCustomchannelsAdunitsList_598133;
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
  var path_598151 = newJObject()
  var query_598152 = newJObject()
  add(query_598152, "fields", newJString(fields))
  add(query_598152, "pageToken", newJString(pageToken))
  add(query_598152, "quotaUser", newJString(quotaUser))
  add(query_598152, "alt", newJString(alt))
  add(query_598152, "includeInactive", newJBool(includeInactive))
  add(query_598152, "oauth_token", newJString(oauthToken))
  add(path_598151, "accountId", newJString(accountId))
  add(path_598151, "customChannelId", newJString(customChannelId))
  add(query_598152, "userIp", newJString(userIp))
  add(query_598152, "maxResults", newJInt(maxResults))
  add(query_598152, "key", newJString(key))
  add(path_598151, "adClientId", newJString(adClientId))
  add(query_598152, "prettyPrint", newJBool(prettyPrint))
  result = call_598150.call(path_598151, query_598152, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_598133(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_598134,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsAdunitsList_598135,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_598153 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsUrlchannelsList_598155(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsUrlchannelsList_598154(path: JsonNode;
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
  var valid_598156 = path.getOrDefault("accountId")
  valid_598156 = validateParameter(valid_598156, JString, required = true,
                                 default = nil)
  if valid_598156 != nil:
    section.add "accountId", valid_598156
  var valid_598157 = path.getOrDefault("adClientId")
  valid_598157 = validateParameter(valid_598157, JString, required = true,
                                 default = nil)
  if valid_598157 != nil:
    section.add "adClientId", valid_598157
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
  var valid_598158 = query.getOrDefault("fields")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "fields", valid_598158
  var valid_598159 = query.getOrDefault("pageToken")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "pageToken", valid_598159
  var valid_598160 = query.getOrDefault("quotaUser")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "quotaUser", valid_598160
  var valid_598161 = query.getOrDefault("alt")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("json"))
  if valid_598161 != nil:
    section.add "alt", valid_598161
  var valid_598162 = query.getOrDefault("oauth_token")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "oauth_token", valid_598162
  var valid_598163 = query.getOrDefault("userIp")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "userIp", valid_598163
  var valid_598164 = query.getOrDefault("maxResults")
  valid_598164 = validateParameter(valid_598164, JInt, required = false, default = nil)
  if valid_598164 != nil:
    section.add "maxResults", valid_598164
  var valid_598165 = query.getOrDefault("key")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "key", valid_598165
  var valid_598166 = query.getOrDefault("prettyPrint")
  valid_598166 = validateParameter(valid_598166, JBool, required = false,
                                 default = newJBool(true))
  if valid_598166 != nil:
    section.add "prettyPrint", valid_598166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598167: Call_AdsenseAccountsUrlchannelsList_598153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_598167.validator(path, query, header, formData, body)
  let scheme = call_598167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598167.url(scheme.get, call_598167.host, call_598167.base,
                         call_598167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598167, url, valid)

proc call*(call_598168: Call_AdsenseAccountsUrlchannelsList_598153;
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
  var path_598169 = newJObject()
  var query_598170 = newJObject()
  add(query_598170, "fields", newJString(fields))
  add(query_598170, "pageToken", newJString(pageToken))
  add(query_598170, "quotaUser", newJString(quotaUser))
  add(query_598170, "alt", newJString(alt))
  add(query_598170, "oauth_token", newJString(oauthToken))
  add(path_598169, "accountId", newJString(accountId))
  add(query_598170, "userIp", newJString(userIp))
  add(query_598170, "maxResults", newJInt(maxResults))
  add(query_598170, "key", newJString(key))
  add(path_598169, "adClientId", newJString(adClientId))
  add(query_598170, "prettyPrint", newJBool(prettyPrint))
  result = call_598168.call(path_598169, query_598170, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_598153(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_598154,
    base: "/adsense/v1.4", url: url_AdsenseAccountsUrlchannelsList_598155,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_598171 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAlertsList_598173(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAlertsList_598172(path: JsonNode; query: JsonNode;
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
  var valid_598174 = path.getOrDefault("accountId")
  valid_598174 = validateParameter(valid_598174, JString, required = true,
                                 default = nil)
  if valid_598174 != nil:
    section.add "accountId", valid_598174
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
  var valid_598175 = query.getOrDefault("locale")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "locale", valid_598175
  var valid_598176 = query.getOrDefault("fields")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "fields", valid_598176
  var valid_598177 = query.getOrDefault("quotaUser")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "quotaUser", valid_598177
  var valid_598178 = query.getOrDefault("alt")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = newJString("json"))
  if valid_598178 != nil:
    section.add "alt", valid_598178
  var valid_598179 = query.getOrDefault("oauth_token")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "oauth_token", valid_598179
  var valid_598180 = query.getOrDefault("userIp")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "userIp", valid_598180
  var valid_598181 = query.getOrDefault("key")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "key", valid_598181
  var valid_598182 = query.getOrDefault("prettyPrint")
  valid_598182 = validateParameter(valid_598182, JBool, required = false,
                                 default = newJBool(true))
  if valid_598182 != nil:
    section.add "prettyPrint", valid_598182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598183: Call_AdsenseAccountsAlertsList_598171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_598183.validator(path, query, header, formData, body)
  let scheme = call_598183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598183.url(scheme.get, call_598183.host, call_598183.base,
                         call_598183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598183, url, valid)

proc call*(call_598184: Call_AdsenseAccountsAlertsList_598171; accountId: string;
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
  var path_598185 = newJObject()
  var query_598186 = newJObject()
  add(query_598186, "locale", newJString(locale))
  add(query_598186, "fields", newJString(fields))
  add(query_598186, "quotaUser", newJString(quotaUser))
  add(query_598186, "alt", newJString(alt))
  add(query_598186, "oauth_token", newJString(oauthToken))
  add(path_598185, "accountId", newJString(accountId))
  add(query_598186, "userIp", newJString(userIp))
  add(query_598186, "key", newJString(key))
  add(query_598186, "prettyPrint", newJBool(prettyPrint))
  result = call_598184.call(path_598185, query_598186, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_598171(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_598172, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAlertsList_598173, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsDelete_598187 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAlertsDelete_598189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsAlertsDelete_598188(path: JsonNode; query: JsonNode;
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
  var valid_598190 = path.getOrDefault("accountId")
  valid_598190 = validateParameter(valid_598190, JString, required = true,
                                 default = nil)
  if valid_598190 != nil:
    section.add "accountId", valid_598190
  var valid_598191 = path.getOrDefault("alertId")
  valid_598191 = validateParameter(valid_598191, JString, required = true,
                                 default = nil)
  if valid_598191 != nil:
    section.add "alertId", valid_598191
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
  var valid_598192 = query.getOrDefault("fields")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "fields", valid_598192
  var valid_598193 = query.getOrDefault("quotaUser")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "quotaUser", valid_598193
  var valid_598194 = query.getOrDefault("alt")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = newJString("json"))
  if valid_598194 != nil:
    section.add "alt", valid_598194
  var valid_598195 = query.getOrDefault("oauth_token")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "oauth_token", valid_598195
  var valid_598196 = query.getOrDefault("userIp")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "userIp", valid_598196
  var valid_598197 = query.getOrDefault("key")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "key", valid_598197
  var valid_598198 = query.getOrDefault("prettyPrint")
  valid_598198 = validateParameter(valid_598198, JBool, required = false,
                                 default = newJBool(true))
  if valid_598198 != nil:
    section.add "prettyPrint", valid_598198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598199: Call_AdsenseAccountsAlertsDelete_598187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ## 
  let valid = call_598199.validator(path, query, header, formData, body)
  let scheme = call_598199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598199.url(scheme.get, call_598199.host, call_598199.base,
                         call_598199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598199, url, valid)

proc call*(call_598200: Call_AdsenseAccountsAlertsDelete_598187; accountId: string;
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
  var path_598201 = newJObject()
  var query_598202 = newJObject()
  add(query_598202, "fields", newJString(fields))
  add(query_598202, "quotaUser", newJString(quotaUser))
  add(query_598202, "alt", newJString(alt))
  add(query_598202, "oauth_token", newJString(oauthToken))
  add(path_598201, "accountId", newJString(accountId))
  add(query_598202, "userIp", newJString(userIp))
  add(query_598202, "key", newJString(key))
  add(path_598201, "alertId", newJString(alertId))
  add(query_598202, "prettyPrint", newJBool(prettyPrint))
  result = call_598200.call(path_598201, query_598202, nil, nil, nil)

var adsenseAccountsAlertsDelete* = Call_AdsenseAccountsAlertsDelete_598187(
    name: "adsenseAccountsAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts/{alertId}",
    validator: validate_AdsenseAccountsAlertsDelete_598188, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAlertsDelete_598189, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsPaymentsList_598203 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsPaymentsList_598205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsPaymentsList_598204(path: JsonNode; query: JsonNode;
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
  var valid_598206 = path.getOrDefault("accountId")
  valid_598206 = validateParameter(valid_598206, JString, required = true,
                                 default = nil)
  if valid_598206 != nil:
    section.add "accountId", valid_598206
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
  var valid_598207 = query.getOrDefault("fields")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "fields", valid_598207
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
  var valid_598212 = query.getOrDefault("key")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "key", valid_598212
  var valid_598213 = query.getOrDefault("prettyPrint")
  valid_598213 = validateParameter(valid_598213, JBool, required = false,
                                 default = newJBool(true))
  if valid_598213 != nil:
    section.add "prettyPrint", valid_598213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598214: Call_AdsenseAccountsPaymentsList_598203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the payments for the specified AdSense account.
  ## 
  let valid = call_598214.validator(path, query, header, formData, body)
  let scheme = call_598214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598214.url(scheme.get, call_598214.host, call_598214.base,
                         call_598214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598214, url, valid)

proc call*(call_598215: Call_AdsenseAccountsPaymentsList_598203; accountId: string;
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
  var path_598216 = newJObject()
  var query_598217 = newJObject()
  add(query_598217, "fields", newJString(fields))
  add(query_598217, "quotaUser", newJString(quotaUser))
  add(query_598217, "alt", newJString(alt))
  add(query_598217, "oauth_token", newJString(oauthToken))
  add(path_598216, "accountId", newJString(accountId))
  add(query_598217, "userIp", newJString(userIp))
  add(query_598217, "key", newJString(key))
  add(query_598217, "prettyPrint", newJBool(prettyPrint))
  result = call_598215.call(path_598216, query_598217, nil, nil, nil)

var adsenseAccountsPaymentsList* = Call_AdsenseAccountsPaymentsList_598203(
    name: "adsenseAccountsPaymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/payments",
    validator: validate_AdsenseAccountsPaymentsList_598204, base: "/adsense/v1.4",
    url: url_AdsenseAccountsPaymentsList_598205, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_598218 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsReportsGenerate_598220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsReportsGenerate_598219(path: JsonNode;
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
  var valid_598221 = path.getOrDefault("accountId")
  valid_598221 = validateParameter(valid_598221, JString, required = true,
                                 default = nil)
  if valid_598221 != nil:
    section.add "accountId", valid_598221
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
  var valid_598222 = query.getOrDefault("useTimezoneReporting")
  valid_598222 = validateParameter(valid_598222, JBool, required = false, default = nil)
  if valid_598222 != nil:
    section.add "useTimezoneReporting", valid_598222
  var valid_598223 = query.getOrDefault("locale")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "locale", valid_598223
  var valid_598224 = query.getOrDefault("fields")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "fields", valid_598224
  var valid_598225 = query.getOrDefault("quotaUser")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "quotaUser", valid_598225
  var valid_598226 = query.getOrDefault("alt")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = newJString("json"))
  if valid_598226 != nil:
    section.add "alt", valid_598226
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598227 = query.getOrDefault("endDate")
  valid_598227 = validateParameter(valid_598227, JString, required = true,
                                 default = nil)
  if valid_598227 != nil:
    section.add "endDate", valid_598227
  var valid_598228 = query.getOrDefault("currency")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "currency", valid_598228
  var valid_598229 = query.getOrDefault("startDate")
  valid_598229 = validateParameter(valid_598229, JString, required = true,
                                 default = nil)
  if valid_598229 != nil:
    section.add "startDate", valid_598229
  var valid_598230 = query.getOrDefault("sort")
  valid_598230 = validateParameter(valid_598230, JArray, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "sort", valid_598230
  var valid_598231 = query.getOrDefault("oauth_token")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "oauth_token", valid_598231
  var valid_598232 = query.getOrDefault("userIp")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "userIp", valid_598232
  var valid_598233 = query.getOrDefault("maxResults")
  valid_598233 = validateParameter(valid_598233, JInt, required = false, default = nil)
  if valid_598233 != nil:
    section.add "maxResults", valid_598233
  var valid_598234 = query.getOrDefault("key")
  valid_598234 = validateParameter(valid_598234, JString, required = false,
                                 default = nil)
  if valid_598234 != nil:
    section.add "key", valid_598234
  var valid_598235 = query.getOrDefault("metric")
  valid_598235 = validateParameter(valid_598235, JArray, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "metric", valid_598235
  var valid_598236 = query.getOrDefault("prettyPrint")
  valid_598236 = validateParameter(valid_598236, JBool, required = false,
                                 default = newJBool(true))
  if valid_598236 != nil:
    section.add "prettyPrint", valid_598236
  var valid_598237 = query.getOrDefault("dimension")
  valid_598237 = validateParameter(valid_598237, JArray, required = false,
                                 default = nil)
  if valid_598237 != nil:
    section.add "dimension", valid_598237
  var valid_598238 = query.getOrDefault("filter")
  valid_598238 = validateParameter(valid_598238, JArray, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "filter", valid_598238
  var valid_598239 = query.getOrDefault("startIndex")
  valid_598239 = validateParameter(valid_598239, JInt, required = false, default = nil)
  if valid_598239 != nil:
    section.add "startIndex", valid_598239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598240: Call_AdsenseAccountsReportsGenerate_598218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598240.validator(path, query, header, formData, body)
  let scheme = call_598240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598240.url(scheme.get, call_598240.host, call_598240.base,
                         call_598240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598240, url, valid)

proc call*(call_598241: Call_AdsenseAccountsReportsGenerate_598218;
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
  var path_598242 = newJObject()
  var query_598243 = newJObject()
  add(query_598243, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_598243, "locale", newJString(locale))
  add(query_598243, "fields", newJString(fields))
  add(query_598243, "quotaUser", newJString(quotaUser))
  add(query_598243, "alt", newJString(alt))
  add(query_598243, "endDate", newJString(endDate))
  add(query_598243, "currency", newJString(currency))
  add(query_598243, "startDate", newJString(startDate))
  if sort != nil:
    query_598243.add "sort", sort
  add(query_598243, "oauth_token", newJString(oauthToken))
  add(path_598242, "accountId", newJString(accountId))
  add(query_598243, "userIp", newJString(userIp))
  add(query_598243, "maxResults", newJInt(maxResults))
  add(query_598243, "key", newJString(key))
  if metric != nil:
    query_598243.add "metric", metric
  add(query_598243, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598243.add "dimension", dimension
  if filter != nil:
    query_598243.add "filter", filter
  add(query_598243, "startIndex", newJInt(startIndex))
  result = call_598241.call(path_598242, query_598243, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_598218(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_598219,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsGenerate_598220,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_598244 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsReportsSavedList_598246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsReportsSavedList_598245(path: JsonNode;
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
  var valid_598247 = path.getOrDefault("accountId")
  valid_598247 = validateParameter(valid_598247, JString, required = true,
                                 default = nil)
  if valid_598247 != nil:
    section.add "accountId", valid_598247
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
  var valid_598248 = query.getOrDefault("fields")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "fields", valid_598248
  var valid_598249 = query.getOrDefault("pageToken")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "pageToken", valid_598249
  var valid_598250 = query.getOrDefault("quotaUser")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "quotaUser", valid_598250
  var valid_598251 = query.getOrDefault("alt")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = newJString("json"))
  if valid_598251 != nil:
    section.add "alt", valid_598251
  var valid_598252 = query.getOrDefault("oauth_token")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "oauth_token", valid_598252
  var valid_598253 = query.getOrDefault("userIp")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "userIp", valid_598253
  var valid_598254 = query.getOrDefault("maxResults")
  valid_598254 = validateParameter(valid_598254, JInt, required = false, default = nil)
  if valid_598254 != nil:
    section.add "maxResults", valid_598254
  var valid_598255 = query.getOrDefault("key")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "key", valid_598255
  var valid_598256 = query.getOrDefault("prettyPrint")
  valid_598256 = validateParameter(valid_598256, JBool, required = false,
                                 default = newJBool(true))
  if valid_598256 != nil:
    section.add "prettyPrint", valid_598256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598257: Call_AdsenseAccountsReportsSavedList_598244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_598257.validator(path, query, header, formData, body)
  let scheme = call_598257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598257.url(scheme.get, call_598257.host, call_598257.base,
                         call_598257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598257, url, valid)

proc call*(call_598258: Call_AdsenseAccountsReportsSavedList_598244;
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
  var path_598259 = newJObject()
  var query_598260 = newJObject()
  add(query_598260, "fields", newJString(fields))
  add(query_598260, "pageToken", newJString(pageToken))
  add(query_598260, "quotaUser", newJString(quotaUser))
  add(query_598260, "alt", newJString(alt))
  add(query_598260, "oauth_token", newJString(oauthToken))
  add(path_598259, "accountId", newJString(accountId))
  add(query_598260, "userIp", newJString(userIp))
  add(query_598260, "maxResults", newJInt(maxResults))
  add(query_598260, "key", newJString(key))
  add(query_598260, "prettyPrint", newJBool(prettyPrint))
  result = call_598258.call(path_598259, query_598260, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_598244(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_598245,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsSavedList_598246,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_598261 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsReportsSavedGenerate_598263(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAccountsReportsSavedGenerate_598262(path: JsonNode;
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
  var valid_598264 = path.getOrDefault("accountId")
  valid_598264 = validateParameter(valid_598264, JString, required = true,
                                 default = nil)
  if valid_598264 != nil:
    section.add "accountId", valid_598264
  var valid_598265 = path.getOrDefault("savedReportId")
  valid_598265 = validateParameter(valid_598265, JString, required = true,
                                 default = nil)
  if valid_598265 != nil:
    section.add "savedReportId", valid_598265
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
  var valid_598266 = query.getOrDefault("locale")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "locale", valid_598266
  var valid_598267 = query.getOrDefault("fields")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "fields", valid_598267
  var valid_598268 = query.getOrDefault("quotaUser")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "quotaUser", valid_598268
  var valid_598269 = query.getOrDefault("alt")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("json"))
  if valid_598269 != nil:
    section.add "alt", valid_598269
  var valid_598270 = query.getOrDefault("oauth_token")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "oauth_token", valid_598270
  var valid_598271 = query.getOrDefault("userIp")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "userIp", valid_598271
  var valid_598272 = query.getOrDefault("maxResults")
  valid_598272 = validateParameter(valid_598272, JInt, required = false, default = nil)
  if valid_598272 != nil:
    section.add "maxResults", valid_598272
  var valid_598273 = query.getOrDefault("key")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "key", valid_598273
  var valid_598274 = query.getOrDefault("prettyPrint")
  valid_598274 = validateParameter(valid_598274, JBool, required = false,
                                 default = newJBool(true))
  if valid_598274 != nil:
    section.add "prettyPrint", valid_598274
  var valid_598275 = query.getOrDefault("startIndex")
  valid_598275 = validateParameter(valid_598275, JInt, required = false, default = nil)
  if valid_598275 != nil:
    section.add "startIndex", valid_598275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598276: Call_AdsenseAccountsReportsSavedGenerate_598261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598276.validator(path, query, header, formData, body)
  let scheme = call_598276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598276.url(scheme.get, call_598276.host, call_598276.base,
                         call_598276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598276, url, valid)

proc call*(call_598277: Call_AdsenseAccountsReportsSavedGenerate_598261;
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
  var path_598278 = newJObject()
  var query_598279 = newJObject()
  add(query_598279, "locale", newJString(locale))
  add(query_598279, "fields", newJString(fields))
  add(query_598279, "quotaUser", newJString(quotaUser))
  add(query_598279, "alt", newJString(alt))
  add(query_598279, "oauth_token", newJString(oauthToken))
  add(path_598278, "accountId", newJString(accountId))
  add(query_598279, "userIp", newJString(userIp))
  add(query_598279, "maxResults", newJInt(maxResults))
  add(path_598278, "savedReportId", newJString(savedReportId))
  add(query_598279, "key", newJString(key))
  add(query_598279, "prettyPrint", newJBool(prettyPrint))
  add(query_598279, "startIndex", newJInt(startIndex))
  result = call_598277.call(path_598278, query_598279, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_598261(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_598262,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsSavedGenerate_598263,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_598280 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsSavedadstylesList_598282(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsSavedadstylesList_598281(path: JsonNode;
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
  var valid_598283 = path.getOrDefault("accountId")
  valid_598283 = validateParameter(valid_598283, JString, required = true,
                                 default = nil)
  if valid_598283 != nil:
    section.add "accountId", valid_598283
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
  var valid_598284 = query.getOrDefault("fields")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "fields", valid_598284
  var valid_598285 = query.getOrDefault("pageToken")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "pageToken", valid_598285
  var valid_598286 = query.getOrDefault("quotaUser")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "quotaUser", valid_598286
  var valid_598287 = query.getOrDefault("alt")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = newJString("json"))
  if valid_598287 != nil:
    section.add "alt", valid_598287
  var valid_598288 = query.getOrDefault("oauth_token")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "oauth_token", valid_598288
  var valid_598289 = query.getOrDefault("userIp")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "userIp", valid_598289
  var valid_598290 = query.getOrDefault("maxResults")
  valid_598290 = validateParameter(valid_598290, JInt, required = false, default = nil)
  if valid_598290 != nil:
    section.add "maxResults", valid_598290
  var valid_598291 = query.getOrDefault("key")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "key", valid_598291
  var valid_598292 = query.getOrDefault("prettyPrint")
  valid_598292 = validateParameter(valid_598292, JBool, required = false,
                                 default = newJBool(true))
  if valid_598292 != nil:
    section.add "prettyPrint", valid_598292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598293: Call_AdsenseAccountsSavedadstylesList_598280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_598293.validator(path, query, header, formData, body)
  let scheme = call_598293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598293.url(scheme.get, call_598293.host, call_598293.base,
                         call_598293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598293, url, valid)

proc call*(call_598294: Call_AdsenseAccountsSavedadstylesList_598280;
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
  var path_598295 = newJObject()
  var query_598296 = newJObject()
  add(query_598296, "fields", newJString(fields))
  add(query_598296, "pageToken", newJString(pageToken))
  add(query_598296, "quotaUser", newJString(quotaUser))
  add(query_598296, "alt", newJString(alt))
  add(query_598296, "oauth_token", newJString(oauthToken))
  add(path_598295, "accountId", newJString(accountId))
  add(query_598296, "userIp", newJString(userIp))
  add(query_598296, "maxResults", newJInt(maxResults))
  add(query_598296, "key", newJString(key))
  add(query_598296, "prettyPrint", newJBool(prettyPrint))
  result = call_598294.call(path_598295, query_598296, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_598280(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_598281,
    base: "/adsense/v1.4", url: url_AdsenseAccountsSavedadstylesList_598282,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_598297 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsSavedadstylesGet_598299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AdsenseAccountsSavedadstylesGet_598298(path: JsonNode;
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
  var valid_598300 = path.getOrDefault("accountId")
  valid_598300 = validateParameter(valid_598300, JString, required = true,
                                 default = nil)
  if valid_598300 != nil:
    section.add "accountId", valid_598300
  var valid_598301 = path.getOrDefault("savedAdStyleId")
  valid_598301 = validateParameter(valid_598301, JString, required = true,
                                 default = nil)
  if valid_598301 != nil:
    section.add "savedAdStyleId", valid_598301
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
  var valid_598302 = query.getOrDefault("fields")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "fields", valid_598302
  var valid_598303 = query.getOrDefault("quotaUser")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = nil)
  if valid_598303 != nil:
    section.add "quotaUser", valid_598303
  var valid_598304 = query.getOrDefault("alt")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = newJString("json"))
  if valid_598304 != nil:
    section.add "alt", valid_598304
  var valid_598305 = query.getOrDefault("oauth_token")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "oauth_token", valid_598305
  var valid_598306 = query.getOrDefault("userIp")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "userIp", valid_598306
  var valid_598307 = query.getOrDefault("key")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "key", valid_598307
  var valid_598308 = query.getOrDefault("prettyPrint")
  valid_598308 = validateParameter(valid_598308, JBool, required = false,
                                 default = newJBool(true))
  if valid_598308 != nil:
    section.add "prettyPrint", valid_598308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598309: Call_AdsenseAccountsSavedadstylesGet_598297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_598309.validator(path, query, header, formData, body)
  let scheme = call_598309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598309.url(scheme.get, call_598309.host, call_598309.base,
                         call_598309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598309, url, valid)

proc call*(call_598310: Call_AdsenseAccountsSavedadstylesGet_598297;
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
  var path_598311 = newJObject()
  var query_598312 = newJObject()
  add(query_598312, "fields", newJString(fields))
  add(query_598312, "quotaUser", newJString(quotaUser))
  add(query_598312, "alt", newJString(alt))
  add(query_598312, "oauth_token", newJString(oauthToken))
  add(path_598311, "accountId", newJString(accountId))
  add(path_598311, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_598312, "userIp", newJString(userIp))
  add(query_598312, "key", newJString(key))
  add(query_598312, "prettyPrint", newJBool(prettyPrint))
  result = call_598310.call(path_598311, query_598312, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_598297(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_598298,
    base: "/adsense/v1.4", url: url_AdsenseAccountsSavedadstylesGet_598299,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_598313 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdclientsList_598315(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_598314(path: JsonNode; query: JsonNode;
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
  var valid_598316 = query.getOrDefault("fields")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "fields", valid_598316
  var valid_598317 = query.getOrDefault("pageToken")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "pageToken", valid_598317
  var valid_598318 = query.getOrDefault("quotaUser")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "quotaUser", valid_598318
  var valid_598319 = query.getOrDefault("alt")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = newJString("json"))
  if valid_598319 != nil:
    section.add "alt", valid_598319
  var valid_598320 = query.getOrDefault("oauth_token")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "oauth_token", valid_598320
  var valid_598321 = query.getOrDefault("userIp")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "userIp", valid_598321
  var valid_598322 = query.getOrDefault("maxResults")
  valid_598322 = validateParameter(valid_598322, JInt, required = false, default = nil)
  if valid_598322 != nil:
    section.add "maxResults", valid_598322
  var valid_598323 = query.getOrDefault("key")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "key", valid_598323
  var valid_598324 = query.getOrDefault("prettyPrint")
  valid_598324 = validateParameter(valid_598324, JBool, required = false,
                                 default = newJBool(true))
  if valid_598324 != nil:
    section.add "prettyPrint", valid_598324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598325: Call_AdsenseAdclientsList_598313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_598325.validator(path, query, header, formData, body)
  let scheme = call_598325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598325.url(scheme.get, call_598325.host, call_598325.base,
                         call_598325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598325, url, valid)

proc call*(call_598326: Call_AdsenseAdclientsList_598313; fields: string = "";
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
  var query_598327 = newJObject()
  add(query_598327, "fields", newJString(fields))
  add(query_598327, "pageToken", newJString(pageToken))
  add(query_598327, "quotaUser", newJString(quotaUser))
  add(query_598327, "alt", newJString(alt))
  add(query_598327, "oauth_token", newJString(oauthToken))
  add(query_598327, "userIp", newJString(userIp))
  add(query_598327, "maxResults", newJInt(maxResults))
  add(query_598327, "key", newJString(key))
  add(query_598327, "prettyPrint", newJBool(prettyPrint))
  result = call_598326.call(nil, query_598327, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_598313(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_598314, base: "/adsense/v1.4",
    url: url_AdsenseAdclientsList_598315, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_598328 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsList_598330(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAdunitsList_598329(path: JsonNode; query: JsonNode;
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
  var valid_598331 = path.getOrDefault("adClientId")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "adClientId", valid_598331
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
  var valid_598332 = query.getOrDefault("fields")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = nil)
  if valid_598332 != nil:
    section.add "fields", valid_598332
  var valid_598333 = query.getOrDefault("pageToken")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "pageToken", valid_598333
  var valid_598334 = query.getOrDefault("quotaUser")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "quotaUser", valid_598334
  var valid_598335 = query.getOrDefault("alt")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = newJString("json"))
  if valid_598335 != nil:
    section.add "alt", valid_598335
  var valid_598336 = query.getOrDefault("includeInactive")
  valid_598336 = validateParameter(valid_598336, JBool, required = false, default = nil)
  if valid_598336 != nil:
    section.add "includeInactive", valid_598336
  var valid_598337 = query.getOrDefault("oauth_token")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "oauth_token", valid_598337
  var valid_598338 = query.getOrDefault("userIp")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "userIp", valid_598338
  var valid_598339 = query.getOrDefault("maxResults")
  valid_598339 = validateParameter(valid_598339, JInt, required = false, default = nil)
  if valid_598339 != nil:
    section.add "maxResults", valid_598339
  var valid_598340 = query.getOrDefault("key")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = nil)
  if valid_598340 != nil:
    section.add "key", valid_598340
  var valid_598341 = query.getOrDefault("prettyPrint")
  valid_598341 = validateParameter(valid_598341, JBool, required = false,
                                 default = newJBool(true))
  if valid_598341 != nil:
    section.add "prettyPrint", valid_598341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598342: Call_AdsenseAdunitsList_598328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_598342.validator(path, query, header, formData, body)
  let scheme = call_598342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598342.url(scheme.get, call_598342.host, call_598342.base,
                         call_598342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598342, url, valid)

proc call*(call_598343: Call_AdsenseAdunitsList_598328; adClientId: string;
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
  var path_598344 = newJObject()
  var query_598345 = newJObject()
  add(query_598345, "fields", newJString(fields))
  add(query_598345, "pageToken", newJString(pageToken))
  add(query_598345, "quotaUser", newJString(quotaUser))
  add(query_598345, "alt", newJString(alt))
  add(query_598345, "includeInactive", newJBool(includeInactive))
  add(query_598345, "oauth_token", newJString(oauthToken))
  add(query_598345, "userIp", newJString(userIp))
  add(query_598345, "maxResults", newJInt(maxResults))
  add(query_598345, "key", newJString(key))
  add(path_598344, "adClientId", newJString(adClientId))
  add(query_598345, "prettyPrint", newJBool(prettyPrint))
  result = call_598343.call(path_598344, query_598345, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_598328(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_598329, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsList_598330, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_598346 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsGet_598348(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseAdunitsGet_598347(path: JsonNode; query: JsonNode;
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
  var valid_598349 = path.getOrDefault("adClientId")
  valid_598349 = validateParameter(valid_598349, JString, required = true,
                                 default = nil)
  if valid_598349 != nil:
    section.add "adClientId", valid_598349
  var valid_598350 = path.getOrDefault("adUnitId")
  valid_598350 = validateParameter(valid_598350, JString, required = true,
                                 default = nil)
  if valid_598350 != nil:
    section.add "adUnitId", valid_598350
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
  var valid_598351 = query.getOrDefault("fields")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "fields", valid_598351
  var valid_598352 = query.getOrDefault("quotaUser")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "quotaUser", valid_598352
  var valid_598353 = query.getOrDefault("alt")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = newJString("json"))
  if valid_598353 != nil:
    section.add "alt", valid_598353
  var valid_598354 = query.getOrDefault("oauth_token")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "oauth_token", valid_598354
  var valid_598355 = query.getOrDefault("userIp")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "userIp", valid_598355
  var valid_598356 = query.getOrDefault("key")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "key", valid_598356
  var valid_598357 = query.getOrDefault("prettyPrint")
  valid_598357 = validateParameter(valid_598357, JBool, required = false,
                                 default = newJBool(true))
  if valid_598357 != nil:
    section.add "prettyPrint", valid_598357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598358: Call_AdsenseAdunitsGet_598346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_598358.validator(path, query, header, formData, body)
  let scheme = call_598358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598358.url(scheme.get, call_598358.host, call_598358.base,
                         call_598358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598358, url, valid)

proc call*(call_598359: Call_AdsenseAdunitsGet_598346; adClientId: string;
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
  var path_598360 = newJObject()
  var query_598361 = newJObject()
  add(query_598361, "fields", newJString(fields))
  add(query_598361, "quotaUser", newJString(quotaUser))
  add(query_598361, "alt", newJString(alt))
  add(query_598361, "oauth_token", newJString(oauthToken))
  add(query_598361, "userIp", newJString(userIp))
  add(query_598361, "key", newJString(key))
  add(path_598360, "adClientId", newJString(adClientId))
  add(path_598360, "adUnitId", newJString(adUnitId))
  add(query_598361, "prettyPrint", newJBool(prettyPrint))
  result = call_598359.call(path_598360, query_598361, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_598346(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_598347, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsGet_598348, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_598362 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsGetAdCode_598364(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/adcode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsGetAdCode_598363(path: JsonNode; query: JsonNode;
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
  var valid_598365 = path.getOrDefault("adClientId")
  valid_598365 = validateParameter(valid_598365, JString, required = true,
                                 default = nil)
  if valid_598365 != nil:
    section.add "adClientId", valid_598365
  var valid_598366 = path.getOrDefault("adUnitId")
  valid_598366 = validateParameter(valid_598366, JString, required = true,
                                 default = nil)
  if valid_598366 != nil:
    section.add "adUnitId", valid_598366
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
  var valid_598367 = query.getOrDefault("fields")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "fields", valid_598367
  var valid_598368 = query.getOrDefault("quotaUser")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "quotaUser", valid_598368
  var valid_598369 = query.getOrDefault("alt")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = newJString("json"))
  if valid_598369 != nil:
    section.add "alt", valid_598369
  var valid_598370 = query.getOrDefault("oauth_token")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "oauth_token", valid_598370
  var valid_598371 = query.getOrDefault("userIp")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "userIp", valid_598371
  var valid_598372 = query.getOrDefault("key")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "key", valid_598372
  var valid_598373 = query.getOrDefault("prettyPrint")
  valid_598373 = validateParameter(valid_598373, JBool, required = false,
                                 default = newJBool(true))
  if valid_598373 != nil:
    section.add "prettyPrint", valid_598373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598374: Call_AdsenseAdunitsGetAdCode_598362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_598374.validator(path, query, header, formData, body)
  let scheme = call_598374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598374.url(scheme.get, call_598374.host, call_598374.base,
                         call_598374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598374, url, valid)

proc call*(call_598375: Call_AdsenseAdunitsGetAdCode_598362; adClientId: string;
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
  var path_598376 = newJObject()
  var query_598377 = newJObject()
  add(query_598377, "fields", newJString(fields))
  add(query_598377, "quotaUser", newJString(quotaUser))
  add(query_598377, "alt", newJString(alt))
  add(query_598377, "oauth_token", newJString(oauthToken))
  add(query_598377, "userIp", newJString(userIp))
  add(query_598377, "key", newJString(key))
  add(path_598376, "adClientId", newJString(adClientId))
  add(path_598376, "adUnitId", newJString(adUnitId))
  add(query_598377, "prettyPrint", newJBool(prettyPrint))
  result = call_598375.call(path_598376, query_598377, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_598362(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_598363, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsGetAdCode_598364, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_598378 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsCustomchannelsList_598380(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "adUnitId"),
               (kind: ConstantSegment, value: "/customchannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAdunitsCustomchannelsList_598379(path: JsonNode;
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
  var valid_598381 = path.getOrDefault("adClientId")
  valid_598381 = validateParameter(valid_598381, JString, required = true,
                                 default = nil)
  if valid_598381 != nil:
    section.add "adClientId", valid_598381
  var valid_598382 = path.getOrDefault("adUnitId")
  valid_598382 = validateParameter(valid_598382, JString, required = true,
                                 default = nil)
  if valid_598382 != nil:
    section.add "adUnitId", valid_598382
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
  var valid_598383 = query.getOrDefault("fields")
  valid_598383 = validateParameter(valid_598383, JString, required = false,
                                 default = nil)
  if valid_598383 != nil:
    section.add "fields", valid_598383
  var valid_598384 = query.getOrDefault("pageToken")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "pageToken", valid_598384
  var valid_598385 = query.getOrDefault("quotaUser")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "quotaUser", valid_598385
  var valid_598386 = query.getOrDefault("alt")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = newJString("json"))
  if valid_598386 != nil:
    section.add "alt", valid_598386
  var valid_598387 = query.getOrDefault("oauth_token")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "oauth_token", valid_598387
  var valid_598388 = query.getOrDefault("userIp")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "userIp", valid_598388
  var valid_598389 = query.getOrDefault("maxResults")
  valid_598389 = validateParameter(valid_598389, JInt, required = false, default = nil)
  if valid_598389 != nil:
    section.add "maxResults", valid_598389
  var valid_598390 = query.getOrDefault("key")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "key", valid_598390
  var valid_598391 = query.getOrDefault("prettyPrint")
  valid_598391 = validateParameter(valid_598391, JBool, required = false,
                                 default = newJBool(true))
  if valid_598391 != nil:
    section.add "prettyPrint", valid_598391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598392: Call_AdsenseAdunitsCustomchannelsList_598378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_598392.validator(path, query, header, formData, body)
  let scheme = call_598392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598392.url(scheme.get, call_598392.host, call_598392.base,
                         call_598392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598392, url, valid)

proc call*(call_598393: Call_AdsenseAdunitsCustomchannelsList_598378;
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
  var path_598394 = newJObject()
  var query_598395 = newJObject()
  add(query_598395, "fields", newJString(fields))
  add(query_598395, "pageToken", newJString(pageToken))
  add(query_598395, "quotaUser", newJString(quotaUser))
  add(query_598395, "alt", newJString(alt))
  add(query_598395, "oauth_token", newJString(oauthToken))
  add(query_598395, "userIp", newJString(userIp))
  add(query_598395, "maxResults", newJInt(maxResults))
  add(query_598395, "key", newJString(key))
  add(path_598394, "adClientId", newJString(adClientId))
  add(path_598394, "adUnitId", newJString(adUnitId))
  add(query_598395, "prettyPrint", newJBool(prettyPrint))
  result = call_598393.call(path_598394, query_598395, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_598378(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_598379,
    base: "/adsense/v1.4", url: url_AdsenseAdunitsCustomchannelsList_598380,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_598396 = ref object of OpenApiRestCall_597424
proc url_AdsenseCustomchannelsList_598398(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsList_598397(path: JsonNode; query: JsonNode;
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
  var valid_598399 = path.getOrDefault("adClientId")
  valid_598399 = validateParameter(valid_598399, JString, required = true,
                                 default = nil)
  if valid_598399 != nil:
    section.add "adClientId", valid_598399
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
  var valid_598400 = query.getOrDefault("fields")
  valid_598400 = validateParameter(valid_598400, JString, required = false,
                                 default = nil)
  if valid_598400 != nil:
    section.add "fields", valid_598400
  var valid_598401 = query.getOrDefault("pageToken")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "pageToken", valid_598401
  var valid_598402 = query.getOrDefault("quotaUser")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "quotaUser", valid_598402
  var valid_598403 = query.getOrDefault("alt")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = newJString("json"))
  if valid_598403 != nil:
    section.add "alt", valid_598403
  var valid_598404 = query.getOrDefault("oauth_token")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "oauth_token", valid_598404
  var valid_598405 = query.getOrDefault("userIp")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "userIp", valid_598405
  var valid_598406 = query.getOrDefault("maxResults")
  valid_598406 = validateParameter(valid_598406, JInt, required = false, default = nil)
  if valid_598406 != nil:
    section.add "maxResults", valid_598406
  var valid_598407 = query.getOrDefault("key")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "key", valid_598407
  var valid_598408 = query.getOrDefault("prettyPrint")
  valid_598408 = validateParameter(valid_598408, JBool, required = false,
                                 default = newJBool(true))
  if valid_598408 != nil:
    section.add "prettyPrint", valid_598408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598409: Call_AdsenseCustomchannelsList_598396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_598409.validator(path, query, header, formData, body)
  let scheme = call_598409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598409.url(scheme.get, call_598409.host, call_598409.base,
                         call_598409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598409, url, valid)

proc call*(call_598410: Call_AdsenseCustomchannelsList_598396; adClientId: string;
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
  var path_598411 = newJObject()
  var query_598412 = newJObject()
  add(query_598412, "fields", newJString(fields))
  add(query_598412, "pageToken", newJString(pageToken))
  add(query_598412, "quotaUser", newJString(quotaUser))
  add(query_598412, "alt", newJString(alt))
  add(query_598412, "oauth_token", newJString(oauthToken))
  add(query_598412, "userIp", newJString(userIp))
  add(query_598412, "maxResults", newJInt(maxResults))
  add(query_598412, "key", newJString(key))
  add(path_598411, "adClientId", newJString(adClientId))
  add(query_598412, "prettyPrint", newJBool(prettyPrint))
  result = call_598410.call(path_598411, query_598412, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_598396(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_598397, base: "/adsense/v1.4",
    url: url_AdsenseCustomchannelsList_598398, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_598413 = ref object of OpenApiRestCall_597424
proc url_AdsenseCustomchannelsGet_598415(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_AdsenseCustomchannelsGet_598414(path: JsonNode; query: JsonNode;
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
  var valid_598416 = path.getOrDefault("customChannelId")
  valid_598416 = validateParameter(valid_598416, JString, required = true,
                                 default = nil)
  if valid_598416 != nil:
    section.add "customChannelId", valid_598416
  var valid_598417 = path.getOrDefault("adClientId")
  valid_598417 = validateParameter(valid_598417, JString, required = true,
                                 default = nil)
  if valid_598417 != nil:
    section.add "adClientId", valid_598417
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
  var valid_598418 = query.getOrDefault("fields")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = nil)
  if valid_598418 != nil:
    section.add "fields", valid_598418
  var valid_598419 = query.getOrDefault("quotaUser")
  valid_598419 = validateParameter(valid_598419, JString, required = false,
                                 default = nil)
  if valid_598419 != nil:
    section.add "quotaUser", valid_598419
  var valid_598420 = query.getOrDefault("alt")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = newJString("json"))
  if valid_598420 != nil:
    section.add "alt", valid_598420
  var valid_598421 = query.getOrDefault("oauth_token")
  valid_598421 = validateParameter(valid_598421, JString, required = false,
                                 default = nil)
  if valid_598421 != nil:
    section.add "oauth_token", valid_598421
  var valid_598422 = query.getOrDefault("userIp")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = nil)
  if valid_598422 != nil:
    section.add "userIp", valid_598422
  var valid_598423 = query.getOrDefault("key")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "key", valid_598423
  var valid_598424 = query.getOrDefault("prettyPrint")
  valid_598424 = validateParameter(valid_598424, JBool, required = false,
                                 default = newJBool(true))
  if valid_598424 != nil:
    section.add "prettyPrint", valid_598424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598425: Call_AdsenseCustomchannelsGet_598413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_598425.validator(path, query, header, formData, body)
  let scheme = call_598425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598425.url(scheme.get, call_598425.host, call_598425.base,
                         call_598425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598425, url, valid)

proc call*(call_598426: Call_AdsenseCustomchannelsGet_598413;
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
  var path_598427 = newJObject()
  var query_598428 = newJObject()
  add(query_598428, "fields", newJString(fields))
  add(query_598428, "quotaUser", newJString(quotaUser))
  add(query_598428, "alt", newJString(alt))
  add(query_598428, "oauth_token", newJString(oauthToken))
  add(path_598427, "customChannelId", newJString(customChannelId))
  add(query_598428, "userIp", newJString(userIp))
  add(query_598428, "key", newJString(key))
  add(path_598427, "adClientId", newJString(adClientId))
  add(query_598428, "prettyPrint", newJBool(prettyPrint))
  result = call_598426.call(path_598427, query_598428, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_598413(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_598414, base: "/adsense/v1.4",
    url: url_AdsenseCustomchannelsGet_598415, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_598429 = ref object of OpenApiRestCall_597424
proc url_AdsenseCustomchannelsAdunitsList_598431(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "customChannelId"),
               (kind: ConstantSegment, value: "/adunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseCustomchannelsAdunitsList_598430(path: JsonNode;
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
  var valid_598432 = path.getOrDefault("customChannelId")
  valid_598432 = validateParameter(valid_598432, JString, required = true,
                                 default = nil)
  if valid_598432 != nil:
    section.add "customChannelId", valid_598432
  var valid_598433 = path.getOrDefault("adClientId")
  valid_598433 = validateParameter(valid_598433, JString, required = true,
                                 default = nil)
  if valid_598433 != nil:
    section.add "adClientId", valid_598433
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
  var valid_598434 = query.getOrDefault("fields")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "fields", valid_598434
  var valid_598435 = query.getOrDefault("pageToken")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "pageToken", valid_598435
  var valid_598436 = query.getOrDefault("quotaUser")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "quotaUser", valid_598436
  var valid_598437 = query.getOrDefault("alt")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = newJString("json"))
  if valid_598437 != nil:
    section.add "alt", valid_598437
  var valid_598438 = query.getOrDefault("includeInactive")
  valid_598438 = validateParameter(valid_598438, JBool, required = false, default = nil)
  if valid_598438 != nil:
    section.add "includeInactive", valid_598438
  var valid_598439 = query.getOrDefault("oauth_token")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = nil)
  if valid_598439 != nil:
    section.add "oauth_token", valid_598439
  var valid_598440 = query.getOrDefault("userIp")
  valid_598440 = validateParameter(valid_598440, JString, required = false,
                                 default = nil)
  if valid_598440 != nil:
    section.add "userIp", valid_598440
  var valid_598441 = query.getOrDefault("maxResults")
  valid_598441 = validateParameter(valid_598441, JInt, required = false, default = nil)
  if valid_598441 != nil:
    section.add "maxResults", valid_598441
  var valid_598442 = query.getOrDefault("key")
  valid_598442 = validateParameter(valid_598442, JString, required = false,
                                 default = nil)
  if valid_598442 != nil:
    section.add "key", valid_598442
  var valid_598443 = query.getOrDefault("prettyPrint")
  valid_598443 = validateParameter(valid_598443, JBool, required = false,
                                 default = newJBool(true))
  if valid_598443 != nil:
    section.add "prettyPrint", valid_598443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598444: Call_AdsenseCustomchannelsAdunitsList_598429;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_598444.validator(path, query, header, formData, body)
  let scheme = call_598444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598444.url(scheme.get, call_598444.host, call_598444.base,
                         call_598444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598444, url, valid)

proc call*(call_598445: Call_AdsenseCustomchannelsAdunitsList_598429;
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
  var path_598446 = newJObject()
  var query_598447 = newJObject()
  add(query_598447, "fields", newJString(fields))
  add(query_598447, "pageToken", newJString(pageToken))
  add(query_598447, "quotaUser", newJString(quotaUser))
  add(query_598447, "alt", newJString(alt))
  add(query_598447, "includeInactive", newJBool(includeInactive))
  add(query_598447, "oauth_token", newJString(oauthToken))
  add(path_598446, "customChannelId", newJString(customChannelId))
  add(query_598447, "userIp", newJString(userIp))
  add(query_598447, "maxResults", newJInt(maxResults))
  add(query_598447, "key", newJString(key))
  add(path_598446, "adClientId", newJString(adClientId))
  add(query_598447, "prettyPrint", newJBool(prettyPrint))
  result = call_598445.call(path_598446, query_598447, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_598429(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_598430,
    base: "/adsense/v1.4", url: url_AdsenseCustomchannelsAdunitsList_598431,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_598448 = ref object of OpenApiRestCall_597424
proc url_AdsenseUrlchannelsList_598450(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseUrlchannelsList_598449(path: JsonNode; query: JsonNode;
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
  var valid_598451 = path.getOrDefault("adClientId")
  valid_598451 = validateParameter(valid_598451, JString, required = true,
                                 default = nil)
  if valid_598451 != nil:
    section.add "adClientId", valid_598451
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
  var valid_598452 = query.getOrDefault("fields")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "fields", valid_598452
  var valid_598453 = query.getOrDefault("pageToken")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "pageToken", valid_598453
  var valid_598454 = query.getOrDefault("quotaUser")
  valid_598454 = validateParameter(valid_598454, JString, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "quotaUser", valid_598454
  var valid_598455 = query.getOrDefault("alt")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = newJString("json"))
  if valid_598455 != nil:
    section.add "alt", valid_598455
  var valid_598456 = query.getOrDefault("oauth_token")
  valid_598456 = validateParameter(valid_598456, JString, required = false,
                                 default = nil)
  if valid_598456 != nil:
    section.add "oauth_token", valid_598456
  var valid_598457 = query.getOrDefault("userIp")
  valid_598457 = validateParameter(valid_598457, JString, required = false,
                                 default = nil)
  if valid_598457 != nil:
    section.add "userIp", valid_598457
  var valid_598458 = query.getOrDefault("maxResults")
  valid_598458 = validateParameter(valid_598458, JInt, required = false, default = nil)
  if valid_598458 != nil:
    section.add "maxResults", valid_598458
  var valid_598459 = query.getOrDefault("key")
  valid_598459 = validateParameter(valid_598459, JString, required = false,
                                 default = nil)
  if valid_598459 != nil:
    section.add "key", valid_598459
  var valid_598460 = query.getOrDefault("prettyPrint")
  valid_598460 = validateParameter(valid_598460, JBool, required = false,
                                 default = newJBool(true))
  if valid_598460 != nil:
    section.add "prettyPrint", valid_598460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598461: Call_AdsenseUrlchannelsList_598448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_598461.validator(path, query, header, formData, body)
  let scheme = call_598461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598461.url(scheme.get, call_598461.host, call_598461.base,
                         call_598461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598461, url, valid)

proc call*(call_598462: Call_AdsenseUrlchannelsList_598448; adClientId: string;
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
  var path_598463 = newJObject()
  var query_598464 = newJObject()
  add(query_598464, "fields", newJString(fields))
  add(query_598464, "pageToken", newJString(pageToken))
  add(query_598464, "quotaUser", newJString(quotaUser))
  add(query_598464, "alt", newJString(alt))
  add(query_598464, "oauth_token", newJString(oauthToken))
  add(query_598464, "userIp", newJString(userIp))
  add(query_598464, "maxResults", newJInt(maxResults))
  add(query_598464, "key", newJString(key))
  add(path_598463, "adClientId", newJString(adClientId))
  add(query_598464, "prettyPrint", newJBool(prettyPrint))
  result = call_598462.call(path_598463, query_598464, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_598448(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_598449, base: "/adsense/v1.4",
    url: url_AdsenseUrlchannelsList_598450, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_598465 = ref object of OpenApiRestCall_597424
proc url_AdsenseAlertsList_598467(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_598466(path: JsonNode; query: JsonNode;
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
  var valid_598468 = query.getOrDefault("locale")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = nil)
  if valid_598468 != nil:
    section.add "locale", valid_598468
  var valid_598469 = query.getOrDefault("fields")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "fields", valid_598469
  var valid_598470 = query.getOrDefault("quotaUser")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "quotaUser", valid_598470
  var valid_598471 = query.getOrDefault("alt")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = newJString("json"))
  if valid_598471 != nil:
    section.add "alt", valid_598471
  var valid_598472 = query.getOrDefault("oauth_token")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "oauth_token", valid_598472
  var valid_598473 = query.getOrDefault("userIp")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "userIp", valid_598473
  var valid_598474 = query.getOrDefault("key")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = nil)
  if valid_598474 != nil:
    section.add "key", valid_598474
  var valid_598475 = query.getOrDefault("prettyPrint")
  valid_598475 = validateParameter(valid_598475, JBool, required = false,
                                 default = newJBool(true))
  if valid_598475 != nil:
    section.add "prettyPrint", valid_598475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598476: Call_AdsenseAlertsList_598465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_598476.validator(path, query, header, formData, body)
  let scheme = call_598476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598476.url(scheme.get, call_598476.host, call_598476.base,
                         call_598476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598476, url, valid)

proc call*(call_598477: Call_AdsenseAlertsList_598465; locale: string = "";
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
  var query_598478 = newJObject()
  add(query_598478, "locale", newJString(locale))
  add(query_598478, "fields", newJString(fields))
  add(query_598478, "quotaUser", newJString(quotaUser))
  add(query_598478, "alt", newJString(alt))
  add(query_598478, "oauth_token", newJString(oauthToken))
  add(query_598478, "userIp", newJString(userIp))
  add(query_598478, "key", newJString(key))
  add(query_598478, "prettyPrint", newJBool(prettyPrint))
  result = call_598477.call(nil, query_598478, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_598465(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_598466, base: "/adsense/v1.4",
    url: url_AdsenseAlertsList_598467, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsDelete_598479 = ref object of OpenApiRestCall_597424
proc url_AdsenseAlertsDelete_598481(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "alertId" in path, "`alertId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/alerts/"),
               (kind: VariableSegment, value: "alertId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseAlertsDelete_598480(path: JsonNode; query: JsonNode;
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
  var valid_598482 = path.getOrDefault("alertId")
  valid_598482 = validateParameter(valid_598482, JString, required = true,
                                 default = nil)
  if valid_598482 != nil:
    section.add "alertId", valid_598482
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
  var valid_598483 = query.getOrDefault("fields")
  valid_598483 = validateParameter(valid_598483, JString, required = false,
                                 default = nil)
  if valid_598483 != nil:
    section.add "fields", valid_598483
  var valid_598484 = query.getOrDefault("quotaUser")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = nil)
  if valid_598484 != nil:
    section.add "quotaUser", valid_598484
  var valid_598485 = query.getOrDefault("alt")
  valid_598485 = validateParameter(valid_598485, JString, required = false,
                                 default = newJString("json"))
  if valid_598485 != nil:
    section.add "alt", valid_598485
  var valid_598486 = query.getOrDefault("oauth_token")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "oauth_token", valid_598486
  var valid_598487 = query.getOrDefault("userIp")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "userIp", valid_598487
  var valid_598488 = query.getOrDefault("key")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "key", valid_598488
  var valid_598489 = query.getOrDefault("prettyPrint")
  valid_598489 = validateParameter(valid_598489, JBool, required = false,
                                 default = newJBool(true))
  if valid_598489 != nil:
    section.add "prettyPrint", valid_598489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598490: Call_AdsenseAlertsDelete_598479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss (delete) the specified alert from the publisher's AdSense account.
  ## 
  let valid = call_598490.validator(path, query, header, formData, body)
  let scheme = call_598490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598490.url(scheme.get, call_598490.host, call_598490.base,
                         call_598490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598490, url, valid)

proc call*(call_598491: Call_AdsenseAlertsDelete_598479; alertId: string;
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
  var path_598492 = newJObject()
  var query_598493 = newJObject()
  add(query_598493, "fields", newJString(fields))
  add(query_598493, "quotaUser", newJString(quotaUser))
  add(query_598493, "alt", newJString(alt))
  add(query_598493, "oauth_token", newJString(oauthToken))
  add(query_598493, "userIp", newJString(userIp))
  add(query_598493, "key", newJString(key))
  add(path_598492, "alertId", newJString(alertId))
  add(query_598493, "prettyPrint", newJBool(prettyPrint))
  result = call_598491.call(path_598492, query_598493, nil, nil, nil)

var adsenseAlertsDelete* = Call_AdsenseAlertsDelete_598479(
    name: "adsenseAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/alerts/{alertId}",
    validator: validate_AdsenseAlertsDelete_598480, base: "/adsense/v1.4",
    url: url_AdsenseAlertsDelete_598481, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_598494 = ref object of OpenApiRestCall_597424
proc url_AdsenseMetadataDimensionsList_598496(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_598495(path: JsonNode; query: JsonNode;
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
  var valid_598497 = query.getOrDefault("fields")
  valid_598497 = validateParameter(valid_598497, JString, required = false,
                                 default = nil)
  if valid_598497 != nil:
    section.add "fields", valid_598497
  var valid_598498 = query.getOrDefault("quotaUser")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "quotaUser", valid_598498
  var valid_598499 = query.getOrDefault("alt")
  valid_598499 = validateParameter(valid_598499, JString, required = false,
                                 default = newJString("json"))
  if valid_598499 != nil:
    section.add "alt", valid_598499
  var valid_598500 = query.getOrDefault("oauth_token")
  valid_598500 = validateParameter(valid_598500, JString, required = false,
                                 default = nil)
  if valid_598500 != nil:
    section.add "oauth_token", valid_598500
  var valid_598501 = query.getOrDefault("userIp")
  valid_598501 = validateParameter(valid_598501, JString, required = false,
                                 default = nil)
  if valid_598501 != nil:
    section.add "userIp", valid_598501
  var valid_598502 = query.getOrDefault("key")
  valid_598502 = validateParameter(valid_598502, JString, required = false,
                                 default = nil)
  if valid_598502 != nil:
    section.add "key", valid_598502
  var valid_598503 = query.getOrDefault("prettyPrint")
  valid_598503 = validateParameter(valid_598503, JBool, required = false,
                                 default = newJBool(true))
  if valid_598503 != nil:
    section.add "prettyPrint", valid_598503
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598504: Call_AdsenseMetadataDimensionsList_598494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_598504.validator(path, query, header, formData, body)
  let scheme = call_598504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598504.url(scheme.get, call_598504.host, call_598504.base,
                         call_598504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598504, url, valid)

proc call*(call_598505: Call_AdsenseMetadataDimensionsList_598494;
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
  var query_598506 = newJObject()
  add(query_598506, "fields", newJString(fields))
  add(query_598506, "quotaUser", newJString(quotaUser))
  add(query_598506, "alt", newJString(alt))
  add(query_598506, "oauth_token", newJString(oauthToken))
  add(query_598506, "userIp", newJString(userIp))
  add(query_598506, "key", newJString(key))
  add(query_598506, "prettyPrint", newJBool(prettyPrint))
  result = call_598505.call(nil, query_598506, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_598494(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_598495,
    base: "/adsense/v1.4", url: url_AdsenseMetadataDimensionsList_598496,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_598507 = ref object of OpenApiRestCall_597424
proc url_AdsenseMetadataMetricsList_598509(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_598508(path: JsonNode; query: JsonNode;
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
  var valid_598510 = query.getOrDefault("fields")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "fields", valid_598510
  var valid_598511 = query.getOrDefault("quotaUser")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "quotaUser", valid_598511
  var valid_598512 = query.getOrDefault("alt")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = newJString("json"))
  if valid_598512 != nil:
    section.add "alt", valid_598512
  var valid_598513 = query.getOrDefault("oauth_token")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "oauth_token", valid_598513
  var valid_598514 = query.getOrDefault("userIp")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "userIp", valid_598514
  var valid_598515 = query.getOrDefault("key")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "key", valid_598515
  var valid_598516 = query.getOrDefault("prettyPrint")
  valid_598516 = validateParameter(valid_598516, JBool, required = false,
                                 default = newJBool(true))
  if valid_598516 != nil:
    section.add "prettyPrint", valid_598516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598517: Call_AdsenseMetadataMetricsList_598507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_598517.validator(path, query, header, formData, body)
  let scheme = call_598517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598517.url(scheme.get, call_598517.host, call_598517.base,
                         call_598517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598517, url, valid)

proc call*(call_598518: Call_AdsenseMetadataMetricsList_598507;
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
  var query_598519 = newJObject()
  add(query_598519, "fields", newJString(fields))
  add(query_598519, "quotaUser", newJString(quotaUser))
  add(query_598519, "alt", newJString(alt))
  add(query_598519, "oauth_token", newJString(oauthToken))
  add(query_598519, "userIp", newJString(userIp))
  add(query_598519, "key", newJString(key))
  add(query_598519, "prettyPrint", newJBool(prettyPrint))
  result = call_598518.call(nil, query_598519, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_598507(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_598508, base: "/adsense/v1.4",
    url: url_AdsenseMetadataMetricsList_598509, schemes: {Scheme.Https})
type
  Call_AdsensePaymentsList_598520 = ref object of OpenApiRestCall_597424
proc url_AdsensePaymentsList_598522(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsensePaymentsList_598521(path: JsonNode; query: JsonNode;
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
  var valid_598523 = query.getOrDefault("fields")
  valid_598523 = validateParameter(valid_598523, JString, required = false,
                                 default = nil)
  if valid_598523 != nil:
    section.add "fields", valid_598523
  var valid_598524 = query.getOrDefault("quotaUser")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "quotaUser", valid_598524
  var valid_598525 = query.getOrDefault("alt")
  valid_598525 = validateParameter(valid_598525, JString, required = false,
                                 default = newJString("json"))
  if valid_598525 != nil:
    section.add "alt", valid_598525
  var valid_598526 = query.getOrDefault("oauth_token")
  valid_598526 = validateParameter(valid_598526, JString, required = false,
                                 default = nil)
  if valid_598526 != nil:
    section.add "oauth_token", valid_598526
  var valid_598527 = query.getOrDefault("userIp")
  valid_598527 = validateParameter(valid_598527, JString, required = false,
                                 default = nil)
  if valid_598527 != nil:
    section.add "userIp", valid_598527
  var valid_598528 = query.getOrDefault("key")
  valid_598528 = validateParameter(valid_598528, JString, required = false,
                                 default = nil)
  if valid_598528 != nil:
    section.add "key", valid_598528
  var valid_598529 = query.getOrDefault("prettyPrint")
  valid_598529 = validateParameter(valid_598529, JBool, required = false,
                                 default = newJBool(true))
  if valid_598529 != nil:
    section.add "prettyPrint", valid_598529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598530: Call_AdsensePaymentsList_598520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the payments for this AdSense account.
  ## 
  let valid = call_598530.validator(path, query, header, formData, body)
  let scheme = call_598530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598530.url(scheme.get, call_598530.host, call_598530.base,
                         call_598530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598530, url, valid)

proc call*(call_598531: Call_AdsensePaymentsList_598520; fields: string = "";
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
  var query_598532 = newJObject()
  add(query_598532, "fields", newJString(fields))
  add(query_598532, "quotaUser", newJString(quotaUser))
  add(query_598532, "alt", newJString(alt))
  add(query_598532, "oauth_token", newJString(oauthToken))
  add(query_598532, "userIp", newJString(userIp))
  add(query_598532, "key", newJString(key))
  add(query_598532, "prettyPrint", newJBool(prettyPrint))
  result = call_598531.call(nil, query_598532, nil, nil, nil)

var adsensePaymentsList* = Call_AdsensePaymentsList_598520(
    name: "adsensePaymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/payments",
    validator: validate_AdsensePaymentsList_598521, base: "/adsense/v1.4",
    url: url_AdsensePaymentsList_598522, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_598533 = ref object of OpenApiRestCall_597424
proc url_AdsenseReportsGenerate_598535(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_598534(path: JsonNode; query: JsonNode;
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
  var valid_598536 = query.getOrDefault("useTimezoneReporting")
  valid_598536 = validateParameter(valid_598536, JBool, required = false, default = nil)
  if valid_598536 != nil:
    section.add "useTimezoneReporting", valid_598536
  var valid_598537 = query.getOrDefault("locale")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = nil)
  if valid_598537 != nil:
    section.add "locale", valid_598537
  var valid_598538 = query.getOrDefault("fields")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "fields", valid_598538
  var valid_598539 = query.getOrDefault("quotaUser")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = nil)
  if valid_598539 != nil:
    section.add "quotaUser", valid_598539
  var valid_598540 = query.getOrDefault("alt")
  valid_598540 = validateParameter(valid_598540, JString, required = false,
                                 default = newJString("json"))
  if valid_598540 != nil:
    section.add "alt", valid_598540
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598541 = query.getOrDefault("endDate")
  valid_598541 = validateParameter(valid_598541, JString, required = true,
                                 default = nil)
  if valid_598541 != nil:
    section.add "endDate", valid_598541
  var valid_598542 = query.getOrDefault("currency")
  valid_598542 = validateParameter(valid_598542, JString, required = false,
                                 default = nil)
  if valid_598542 != nil:
    section.add "currency", valid_598542
  var valid_598543 = query.getOrDefault("startDate")
  valid_598543 = validateParameter(valid_598543, JString, required = true,
                                 default = nil)
  if valid_598543 != nil:
    section.add "startDate", valid_598543
  var valid_598544 = query.getOrDefault("sort")
  valid_598544 = validateParameter(valid_598544, JArray, required = false,
                                 default = nil)
  if valid_598544 != nil:
    section.add "sort", valid_598544
  var valid_598545 = query.getOrDefault("oauth_token")
  valid_598545 = validateParameter(valid_598545, JString, required = false,
                                 default = nil)
  if valid_598545 != nil:
    section.add "oauth_token", valid_598545
  var valid_598546 = query.getOrDefault("accountId")
  valid_598546 = validateParameter(valid_598546, JArray, required = false,
                                 default = nil)
  if valid_598546 != nil:
    section.add "accountId", valid_598546
  var valid_598547 = query.getOrDefault("userIp")
  valid_598547 = validateParameter(valid_598547, JString, required = false,
                                 default = nil)
  if valid_598547 != nil:
    section.add "userIp", valid_598547
  var valid_598548 = query.getOrDefault("maxResults")
  valid_598548 = validateParameter(valid_598548, JInt, required = false, default = nil)
  if valid_598548 != nil:
    section.add "maxResults", valid_598548
  var valid_598549 = query.getOrDefault("key")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "key", valid_598549
  var valid_598550 = query.getOrDefault("metric")
  valid_598550 = validateParameter(valid_598550, JArray, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "metric", valid_598550
  var valid_598551 = query.getOrDefault("prettyPrint")
  valid_598551 = validateParameter(valid_598551, JBool, required = false,
                                 default = newJBool(true))
  if valid_598551 != nil:
    section.add "prettyPrint", valid_598551
  var valid_598552 = query.getOrDefault("dimension")
  valid_598552 = validateParameter(valid_598552, JArray, required = false,
                                 default = nil)
  if valid_598552 != nil:
    section.add "dimension", valid_598552
  var valid_598553 = query.getOrDefault("filter")
  valid_598553 = validateParameter(valid_598553, JArray, required = false,
                                 default = nil)
  if valid_598553 != nil:
    section.add "filter", valid_598553
  var valid_598554 = query.getOrDefault("startIndex")
  valid_598554 = validateParameter(valid_598554, JInt, required = false, default = nil)
  if valid_598554 != nil:
    section.add "startIndex", valid_598554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598555: Call_AdsenseReportsGenerate_598533; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598555.validator(path, query, header, formData, body)
  let scheme = call_598555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598555.url(scheme.get, call_598555.host, call_598555.base,
                         call_598555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598555, url, valid)

proc call*(call_598556: Call_AdsenseReportsGenerate_598533; endDate: string;
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
  var query_598557 = newJObject()
  add(query_598557, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_598557, "locale", newJString(locale))
  add(query_598557, "fields", newJString(fields))
  add(query_598557, "quotaUser", newJString(quotaUser))
  add(query_598557, "alt", newJString(alt))
  add(query_598557, "endDate", newJString(endDate))
  add(query_598557, "currency", newJString(currency))
  add(query_598557, "startDate", newJString(startDate))
  if sort != nil:
    query_598557.add "sort", sort
  add(query_598557, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_598557.add "accountId", accountId
  add(query_598557, "userIp", newJString(userIp))
  add(query_598557, "maxResults", newJInt(maxResults))
  add(query_598557, "key", newJString(key))
  if metric != nil:
    query_598557.add "metric", metric
  add(query_598557, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598557.add "dimension", dimension
  if filter != nil:
    query_598557.add "filter", filter
  add(query_598557, "startIndex", newJInt(startIndex))
  result = call_598556.call(nil, query_598557, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_598533(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_598534, base: "/adsense/v1.4",
    url: url_AdsenseReportsGenerate_598535, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_598558 = ref object of OpenApiRestCall_597424
proc url_AdsenseReportsSavedList_598560(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_598559(path: JsonNode; query: JsonNode;
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
  var valid_598561 = query.getOrDefault("fields")
  valid_598561 = validateParameter(valid_598561, JString, required = false,
                                 default = nil)
  if valid_598561 != nil:
    section.add "fields", valid_598561
  var valid_598562 = query.getOrDefault("pageToken")
  valid_598562 = validateParameter(valid_598562, JString, required = false,
                                 default = nil)
  if valid_598562 != nil:
    section.add "pageToken", valid_598562
  var valid_598563 = query.getOrDefault("quotaUser")
  valid_598563 = validateParameter(valid_598563, JString, required = false,
                                 default = nil)
  if valid_598563 != nil:
    section.add "quotaUser", valid_598563
  var valid_598564 = query.getOrDefault("alt")
  valid_598564 = validateParameter(valid_598564, JString, required = false,
                                 default = newJString("json"))
  if valid_598564 != nil:
    section.add "alt", valid_598564
  var valid_598565 = query.getOrDefault("oauth_token")
  valid_598565 = validateParameter(valid_598565, JString, required = false,
                                 default = nil)
  if valid_598565 != nil:
    section.add "oauth_token", valid_598565
  var valid_598566 = query.getOrDefault("userIp")
  valid_598566 = validateParameter(valid_598566, JString, required = false,
                                 default = nil)
  if valid_598566 != nil:
    section.add "userIp", valid_598566
  var valid_598567 = query.getOrDefault("maxResults")
  valid_598567 = validateParameter(valid_598567, JInt, required = false, default = nil)
  if valid_598567 != nil:
    section.add "maxResults", valid_598567
  var valid_598568 = query.getOrDefault("key")
  valid_598568 = validateParameter(valid_598568, JString, required = false,
                                 default = nil)
  if valid_598568 != nil:
    section.add "key", valid_598568
  var valid_598569 = query.getOrDefault("prettyPrint")
  valid_598569 = validateParameter(valid_598569, JBool, required = false,
                                 default = newJBool(true))
  if valid_598569 != nil:
    section.add "prettyPrint", valid_598569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598570: Call_AdsenseReportsSavedList_598558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_598570.validator(path, query, header, formData, body)
  let scheme = call_598570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598570.url(scheme.get, call_598570.host, call_598570.base,
                         call_598570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598570, url, valid)

proc call*(call_598571: Call_AdsenseReportsSavedList_598558; fields: string = "";
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
  var query_598572 = newJObject()
  add(query_598572, "fields", newJString(fields))
  add(query_598572, "pageToken", newJString(pageToken))
  add(query_598572, "quotaUser", newJString(quotaUser))
  add(query_598572, "alt", newJString(alt))
  add(query_598572, "oauth_token", newJString(oauthToken))
  add(query_598572, "userIp", newJString(userIp))
  add(query_598572, "maxResults", newJInt(maxResults))
  add(query_598572, "key", newJString(key))
  add(query_598572, "prettyPrint", newJBool(prettyPrint))
  result = call_598571.call(nil, query_598572, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_598558(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_598559, base: "/adsense/v1.4",
    url: url_AdsenseReportsSavedList_598560, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_598573 = ref object of OpenApiRestCall_597424
proc url_AdsenseReportsSavedGenerate_598575(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_AdsenseReportsSavedGenerate_598574(path: JsonNode; query: JsonNode;
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
  var valid_598576 = path.getOrDefault("savedReportId")
  valid_598576 = validateParameter(valid_598576, JString, required = true,
                                 default = nil)
  if valid_598576 != nil:
    section.add "savedReportId", valid_598576
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
  var valid_598577 = query.getOrDefault("locale")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "locale", valid_598577
  var valid_598578 = query.getOrDefault("fields")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "fields", valid_598578
  var valid_598579 = query.getOrDefault("quotaUser")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "quotaUser", valid_598579
  var valid_598580 = query.getOrDefault("alt")
  valid_598580 = validateParameter(valid_598580, JString, required = false,
                                 default = newJString("json"))
  if valid_598580 != nil:
    section.add "alt", valid_598580
  var valid_598581 = query.getOrDefault("oauth_token")
  valid_598581 = validateParameter(valid_598581, JString, required = false,
                                 default = nil)
  if valid_598581 != nil:
    section.add "oauth_token", valid_598581
  var valid_598582 = query.getOrDefault("userIp")
  valid_598582 = validateParameter(valid_598582, JString, required = false,
                                 default = nil)
  if valid_598582 != nil:
    section.add "userIp", valid_598582
  var valid_598583 = query.getOrDefault("maxResults")
  valid_598583 = validateParameter(valid_598583, JInt, required = false, default = nil)
  if valid_598583 != nil:
    section.add "maxResults", valid_598583
  var valid_598584 = query.getOrDefault("key")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = nil)
  if valid_598584 != nil:
    section.add "key", valid_598584
  var valid_598585 = query.getOrDefault("prettyPrint")
  valid_598585 = validateParameter(valid_598585, JBool, required = false,
                                 default = newJBool(true))
  if valid_598585 != nil:
    section.add "prettyPrint", valid_598585
  var valid_598586 = query.getOrDefault("startIndex")
  valid_598586 = validateParameter(valid_598586, JInt, required = false, default = nil)
  if valid_598586 != nil:
    section.add "startIndex", valid_598586
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598587: Call_AdsenseReportsSavedGenerate_598573; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598587.validator(path, query, header, formData, body)
  let scheme = call_598587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598587.url(scheme.get, call_598587.host, call_598587.base,
                         call_598587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598587, url, valid)

proc call*(call_598588: Call_AdsenseReportsSavedGenerate_598573;
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
  var path_598589 = newJObject()
  var query_598590 = newJObject()
  add(query_598590, "locale", newJString(locale))
  add(query_598590, "fields", newJString(fields))
  add(query_598590, "quotaUser", newJString(quotaUser))
  add(query_598590, "alt", newJString(alt))
  add(query_598590, "oauth_token", newJString(oauthToken))
  add(query_598590, "userIp", newJString(userIp))
  add(query_598590, "maxResults", newJInt(maxResults))
  add(path_598589, "savedReportId", newJString(savedReportId))
  add(query_598590, "key", newJString(key))
  add(query_598590, "prettyPrint", newJBool(prettyPrint))
  add(query_598590, "startIndex", newJInt(startIndex))
  result = call_598588.call(path_598589, query_598590, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_598573(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_598574, base: "/adsense/v1.4",
    url: url_AdsenseReportsSavedGenerate_598575, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_598591 = ref object of OpenApiRestCall_597424
proc url_AdsenseSavedadstylesList_598593(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_598592(path: JsonNode; query: JsonNode;
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
  var valid_598594 = query.getOrDefault("fields")
  valid_598594 = validateParameter(valid_598594, JString, required = false,
                                 default = nil)
  if valid_598594 != nil:
    section.add "fields", valid_598594
  var valid_598595 = query.getOrDefault("pageToken")
  valid_598595 = validateParameter(valid_598595, JString, required = false,
                                 default = nil)
  if valid_598595 != nil:
    section.add "pageToken", valid_598595
  var valid_598596 = query.getOrDefault("quotaUser")
  valid_598596 = validateParameter(valid_598596, JString, required = false,
                                 default = nil)
  if valid_598596 != nil:
    section.add "quotaUser", valid_598596
  var valid_598597 = query.getOrDefault("alt")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = newJString("json"))
  if valid_598597 != nil:
    section.add "alt", valid_598597
  var valid_598598 = query.getOrDefault("oauth_token")
  valid_598598 = validateParameter(valid_598598, JString, required = false,
                                 default = nil)
  if valid_598598 != nil:
    section.add "oauth_token", valid_598598
  var valid_598599 = query.getOrDefault("userIp")
  valid_598599 = validateParameter(valid_598599, JString, required = false,
                                 default = nil)
  if valid_598599 != nil:
    section.add "userIp", valid_598599
  var valid_598600 = query.getOrDefault("maxResults")
  valid_598600 = validateParameter(valid_598600, JInt, required = false, default = nil)
  if valid_598600 != nil:
    section.add "maxResults", valid_598600
  var valid_598601 = query.getOrDefault("key")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = nil)
  if valid_598601 != nil:
    section.add "key", valid_598601
  var valid_598602 = query.getOrDefault("prettyPrint")
  valid_598602 = validateParameter(valid_598602, JBool, required = false,
                                 default = newJBool(true))
  if valid_598602 != nil:
    section.add "prettyPrint", valid_598602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598603: Call_AdsenseSavedadstylesList_598591; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_598603.validator(path, query, header, formData, body)
  let scheme = call_598603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598603.url(scheme.get, call_598603.host, call_598603.base,
                         call_598603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598603, url, valid)

proc call*(call_598604: Call_AdsenseSavedadstylesList_598591; fields: string = "";
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
  var query_598605 = newJObject()
  add(query_598605, "fields", newJString(fields))
  add(query_598605, "pageToken", newJString(pageToken))
  add(query_598605, "quotaUser", newJString(quotaUser))
  add(query_598605, "alt", newJString(alt))
  add(query_598605, "oauth_token", newJString(oauthToken))
  add(query_598605, "userIp", newJString(userIp))
  add(query_598605, "maxResults", newJInt(maxResults))
  add(query_598605, "key", newJString(key))
  add(query_598605, "prettyPrint", newJBool(prettyPrint))
  result = call_598604.call(nil, query_598605, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_598591(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_598592, base: "/adsense/v1.4",
    url: url_AdsenseSavedadstylesList_598593, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_598606 = ref object of OpenApiRestCall_597424
proc url_AdsenseSavedadstylesGet_598608(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "savedAdStyleId" in path, "`savedAdStyleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/savedadstyles/"),
               (kind: VariableSegment, value: "savedAdStyleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsenseSavedadstylesGet_598607(path: JsonNode; query: JsonNode;
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
  var valid_598609 = path.getOrDefault("savedAdStyleId")
  valid_598609 = validateParameter(valid_598609, JString, required = true,
                                 default = nil)
  if valid_598609 != nil:
    section.add "savedAdStyleId", valid_598609
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
  var valid_598610 = query.getOrDefault("fields")
  valid_598610 = validateParameter(valid_598610, JString, required = false,
                                 default = nil)
  if valid_598610 != nil:
    section.add "fields", valid_598610
  var valid_598611 = query.getOrDefault("quotaUser")
  valid_598611 = validateParameter(valid_598611, JString, required = false,
                                 default = nil)
  if valid_598611 != nil:
    section.add "quotaUser", valid_598611
  var valid_598612 = query.getOrDefault("alt")
  valid_598612 = validateParameter(valid_598612, JString, required = false,
                                 default = newJString("json"))
  if valid_598612 != nil:
    section.add "alt", valid_598612
  var valid_598613 = query.getOrDefault("oauth_token")
  valid_598613 = validateParameter(valid_598613, JString, required = false,
                                 default = nil)
  if valid_598613 != nil:
    section.add "oauth_token", valid_598613
  var valid_598614 = query.getOrDefault("userIp")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "userIp", valid_598614
  var valid_598615 = query.getOrDefault("key")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = nil)
  if valid_598615 != nil:
    section.add "key", valid_598615
  var valid_598616 = query.getOrDefault("prettyPrint")
  valid_598616 = validateParameter(valid_598616, JBool, required = false,
                                 default = newJBool(true))
  if valid_598616 != nil:
    section.add "prettyPrint", valid_598616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598617: Call_AdsenseSavedadstylesGet_598606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_598617.validator(path, query, header, formData, body)
  let scheme = call_598617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598617.url(scheme.get, call_598617.host, call_598617.base,
                         call_598617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598617, url, valid)

proc call*(call_598618: Call_AdsenseSavedadstylesGet_598606;
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
  var path_598619 = newJObject()
  var query_598620 = newJObject()
  add(query_598620, "fields", newJString(fields))
  add(query_598620, "quotaUser", newJString(quotaUser))
  add(query_598620, "alt", newJString(alt))
  add(query_598620, "oauth_token", newJString(oauthToken))
  add(path_598619, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_598620, "userIp", newJString(userIp))
  add(query_598620, "key", newJString(key))
  add(query_598620, "prettyPrint", newJBool(prettyPrint))
  result = call_598618.call(path_598619, query_598620, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_598606(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_598607, base: "/adsense/v1.4",
    url: url_AdsenseSavedadstylesGet_598608, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
