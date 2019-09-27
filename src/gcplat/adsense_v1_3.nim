
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: AdSense Management
## version: v1.3
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
    validator: validate_AdsenseAccountsList_597694, base: "/adsense/v1.3",
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to get information about.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
    validator: validate_AdsenseAccountsGet_597964, base: "/adsense/v1.3",
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to list ad clients.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdclientsList_597995,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_598010 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsList_598012(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsList_598011(path: JsonNode; query: JsonNode;
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
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
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
  var valid_598016 = query.getOrDefault("pageToken")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "pageToken", valid_598016
  var valid_598017 = query.getOrDefault("quotaUser")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "quotaUser", valid_598017
  var valid_598018 = query.getOrDefault("alt")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("json"))
  if valid_598018 != nil:
    section.add "alt", valid_598018
  var valid_598019 = query.getOrDefault("includeInactive")
  valid_598019 = validateParameter(valid_598019, JBool, required = false, default = nil)
  if valid_598019 != nil:
    section.add "includeInactive", valid_598019
  var valid_598020 = query.getOrDefault("oauth_token")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "oauth_token", valid_598020
  var valid_598021 = query.getOrDefault("userIp")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "userIp", valid_598021
  var valid_598022 = query.getOrDefault("maxResults")
  valid_598022 = validateParameter(valid_598022, JInt, required = false, default = nil)
  if valid_598022 != nil:
    section.add "maxResults", valid_598022
  var valid_598023 = query.getOrDefault("key")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "key", valid_598023
  var valid_598024 = query.getOrDefault("prettyPrint")
  valid_598024 = validateParameter(valid_598024, JBool, required = false,
                                 default = newJBool(true))
  if valid_598024 != nil:
    section.add "prettyPrint", valid_598024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598025: Call_AdsenseAccountsAdunitsList_598010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_598025.validator(path, query, header, formData, body)
  let scheme = call_598025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598025.url(scheme.get, call_598025.host, call_598025.base,
                         call_598025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598025, url, valid)

proc call*(call_598026: Call_AdsenseAccountsAdunitsList_598010; accountId: string;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598027 = newJObject()
  var query_598028 = newJObject()
  add(query_598028, "fields", newJString(fields))
  add(query_598028, "pageToken", newJString(pageToken))
  add(query_598028, "quotaUser", newJString(quotaUser))
  add(query_598028, "alt", newJString(alt))
  add(query_598028, "includeInactive", newJBool(includeInactive))
  add(query_598028, "oauth_token", newJString(oauthToken))
  add(path_598027, "accountId", newJString(accountId))
  add(query_598028, "userIp", newJString(userIp))
  add(query_598028, "maxResults", newJInt(maxResults))
  add(query_598028, "key", newJString(key))
  add(path_598027, "adClientId", newJString(adClientId))
  add(query_598028, "prettyPrint", newJBool(prettyPrint))
  result = call_598026.call(path_598027, query_598028, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_598010(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_598011, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsList_598012, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_598029 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsGet_598031(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGet_598030(path: JsonNode; query: JsonNode;
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
  var valid_598032 = path.getOrDefault("accountId")
  valid_598032 = validateParameter(valid_598032, JString, required = true,
                                 default = nil)
  if valid_598032 != nil:
    section.add "accountId", valid_598032
  var valid_598033 = path.getOrDefault("adClientId")
  valid_598033 = validateParameter(valid_598033, JString, required = true,
                                 default = nil)
  if valid_598033 != nil:
    section.add "adClientId", valid_598033
  var valid_598034 = path.getOrDefault("adUnitId")
  valid_598034 = validateParameter(valid_598034, JString, required = true,
                                 default = nil)
  if valid_598034 != nil:
    section.add "adUnitId", valid_598034
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598035 = query.getOrDefault("fields")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "fields", valid_598035
  var valid_598036 = query.getOrDefault("quotaUser")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "quotaUser", valid_598036
  var valid_598037 = query.getOrDefault("alt")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("json"))
  if valid_598037 != nil:
    section.add "alt", valid_598037
  var valid_598038 = query.getOrDefault("oauth_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "oauth_token", valid_598038
  var valid_598039 = query.getOrDefault("userIp")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "userIp", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("prettyPrint")
  valid_598041 = validateParameter(valid_598041, JBool, required = false,
                                 default = newJBool(true))
  if valid_598041 != nil:
    section.add "prettyPrint", valid_598041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598042: Call_AdsenseAccountsAdunitsGet_598029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_598042.validator(path, query, header, formData, body)
  let scheme = call_598042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598042.url(scheme.get, call_598042.host, call_598042.base,
                         call_598042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598042, url, valid)

proc call*(call_598043: Call_AdsenseAccountsAdunitsGet_598029; accountId: string;
          adClientId: string; adUnitId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsGet
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598044 = newJObject()
  var query_598045 = newJObject()
  add(query_598045, "fields", newJString(fields))
  add(query_598045, "quotaUser", newJString(quotaUser))
  add(query_598045, "alt", newJString(alt))
  add(query_598045, "oauth_token", newJString(oauthToken))
  add(path_598044, "accountId", newJString(accountId))
  add(query_598045, "userIp", newJString(userIp))
  add(query_598045, "key", newJString(key))
  add(path_598044, "adClientId", newJString(adClientId))
  add(path_598044, "adUnitId", newJString(adUnitId))
  add(query_598045, "prettyPrint", newJBool(prettyPrint))
  result = call_598043.call(path_598044, query_598045, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_598029(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_598030, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsGet_598031, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_598046 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsGetAdCode_598048(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGetAdCode_598047(path: JsonNode;
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
  var valid_598049 = path.getOrDefault("accountId")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "accountId", valid_598049
  var valid_598050 = path.getOrDefault("adClientId")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "adClientId", valid_598050
  var valid_598051 = path.getOrDefault("adUnitId")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "adUnitId", valid_598051
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598052 = query.getOrDefault("fields")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "fields", valid_598052
  var valid_598053 = query.getOrDefault("quotaUser")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "quotaUser", valid_598053
  var valid_598054 = query.getOrDefault("alt")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = newJString("json"))
  if valid_598054 != nil:
    section.add "alt", valid_598054
  var valid_598055 = query.getOrDefault("oauth_token")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "oauth_token", valid_598055
  var valid_598056 = query.getOrDefault("userIp")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "userIp", valid_598056
  var valid_598057 = query.getOrDefault("key")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "key", valid_598057
  var valid_598058 = query.getOrDefault("prettyPrint")
  valid_598058 = validateParameter(valid_598058, JBool, required = false,
                                 default = newJBool(true))
  if valid_598058 != nil:
    section.add "prettyPrint", valid_598058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598059: Call_AdsenseAccountsAdunitsGetAdCode_598046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_598059.validator(path, query, header, formData, body)
  let scheme = call_598059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598059.url(scheme.get, call_598059.host, call_598059.base,
                         call_598059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598059, url, valid)

proc call*(call_598060: Call_AdsenseAccountsAdunitsGetAdCode_598046;
          accountId: string; adClientId: string; adUnitId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598061 = newJObject()
  var query_598062 = newJObject()
  add(query_598062, "fields", newJString(fields))
  add(query_598062, "quotaUser", newJString(quotaUser))
  add(query_598062, "alt", newJString(alt))
  add(query_598062, "oauth_token", newJString(oauthToken))
  add(path_598061, "accountId", newJString(accountId))
  add(query_598062, "userIp", newJString(userIp))
  add(query_598062, "key", newJString(key))
  add(path_598061, "adClientId", newJString(adClientId))
  add(path_598061, "adUnitId", newJString(adUnitId))
  add(query_598062, "prettyPrint", newJBool(prettyPrint))
  result = call_598060.call(path_598061, query_598062, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_598046(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_598047,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsGetAdCode_598048,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_598063 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAdunitsCustomchannelsList_598065(protocol: Scheme;
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

proc validate_AdsenseAccountsAdunitsCustomchannelsList_598064(path: JsonNode;
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
  var valid_598066 = path.getOrDefault("accountId")
  valid_598066 = validateParameter(valid_598066, JString, required = true,
                                 default = nil)
  if valid_598066 != nil:
    section.add "accountId", valid_598066
  var valid_598067 = path.getOrDefault("adClientId")
  valid_598067 = validateParameter(valid_598067, JString, required = true,
                                 default = nil)
  if valid_598067 != nil:
    section.add "adClientId", valid_598067
  var valid_598068 = path.getOrDefault("adUnitId")
  valid_598068 = validateParameter(valid_598068, JString, required = true,
                                 default = nil)
  if valid_598068 != nil:
    section.add "adUnitId", valid_598068
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598069 = query.getOrDefault("fields")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "fields", valid_598069
  var valid_598070 = query.getOrDefault("pageToken")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "pageToken", valid_598070
  var valid_598071 = query.getOrDefault("quotaUser")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "quotaUser", valid_598071
  var valid_598072 = query.getOrDefault("alt")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = newJString("json"))
  if valid_598072 != nil:
    section.add "alt", valid_598072
  var valid_598073 = query.getOrDefault("oauth_token")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "oauth_token", valid_598073
  var valid_598074 = query.getOrDefault("userIp")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "userIp", valid_598074
  var valid_598075 = query.getOrDefault("maxResults")
  valid_598075 = validateParameter(valid_598075, JInt, required = false, default = nil)
  if valid_598075 != nil:
    section.add "maxResults", valid_598075
  var valid_598076 = query.getOrDefault("key")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "key", valid_598076
  var valid_598077 = query.getOrDefault("prettyPrint")
  valid_598077 = validateParameter(valid_598077, JBool, required = false,
                                 default = newJBool(true))
  if valid_598077 != nil:
    section.add "prettyPrint", valid_598077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598078: Call_AdsenseAccountsAdunitsCustomchannelsList_598063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_598078.validator(path, query, header, formData, body)
  let scheme = call_598078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598078.url(scheme.get, call_598078.host, call_598078.base,
                         call_598078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598078, url, valid)

proc call*(call_598079: Call_AdsenseAccountsAdunitsCustomchannelsList_598063;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  var path_598080 = newJObject()
  var query_598081 = newJObject()
  add(query_598081, "fields", newJString(fields))
  add(query_598081, "pageToken", newJString(pageToken))
  add(query_598081, "quotaUser", newJString(quotaUser))
  add(query_598081, "alt", newJString(alt))
  add(query_598081, "oauth_token", newJString(oauthToken))
  add(path_598080, "accountId", newJString(accountId))
  add(query_598081, "userIp", newJString(userIp))
  add(query_598081, "maxResults", newJInt(maxResults))
  add(query_598081, "key", newJString(key))
  add(path_598080, "adClientId", newJString(adClientId))
  add(path_598080, "adUnitId", newJString(adUnitId))
  add(query_598081, "prettyPrint", newJBool(prettyPrint))
  result = call_598079.call(path_598080, query_598081, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_598063(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_598064,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsCustomchannelsList_598065,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_598082 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsCustomchannelsList_598084(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsList_598083(path: JsonNode;
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
  var valid_598085 = path.getOrDefault("accountId")
  valid_598085 = validateParameter(valid_598085, JString, required = true,
                                 default = nil)
  if valid_598085 != nil:
    section.add "accountId", valid_598085
  var valid_598086 = path.getOrDefault("adClientId")
  valid_598086 = validateParameter(valid_598086, JString, required = true,
                                 default = nil)
  if valid_598086 != nil:
    section.add "adClientId", valid_598086
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598087 = query.getOrDefault("fields")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "fields", valid_598087
  var valid_598088 = query.getOrDefault("pageToken")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "pageToken", valid_598088
  var valid_598089 = query.getOrDefault("quotaUser")
  valid_598089 = validateParameter(valid_598089, JString, required = false,
                                 default = nil)
  if valid_598089 != nil:
    section.add "quotaUser", valid_598089
  var valid_598090 = query.getOrDefault("alt")
  valid_598090 = validateParameter(valid_598090, JString, required = false,
                                 default = newJString("json"))
  if valid_598090 != nil:
    section.add "alt", valid_598090
  var valid_598091 = query.getOrDefault("oauth_token")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "oauth_token", valid_598091
  var valid_598092 = query.getOrDefault("userIp")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "userIp", valid_598092
  var valid_598093 = query.getOrDefault("maxResults")
  valid_598093 = validateParameter(valid_598093, JInt, required = false, default = nil)
  if valid_598093 != nil:
    section.add "maxResults", valid_598093
  var valid_598094 = query.getOrDefault("key")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "key", valid_598094
  var valid_598095 = query.getOrDefault("prettyPrint")
  valid_598095 = validateParameter(valid_598095, JBool, required = false,
                                 default = newJBool(true))
  if valid_598095 != nil:
    section.add "prettyPrint", valid_598095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598096: Call_AdsenseAccountsCustomchannelsList_598082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_598096.validator(path, query, header, formData, body)
  let scheme = call_598096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598096.url(scheme.get, call_598096.host, call_598096.base,
                         call_598096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598096, url, valid)

proc call*(call_598097: Call_AdsenseAccountsCustomchannelsList_598082;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598098 = newJObject()
  var query_598099 = newJObject()
  add(query_598099, "fields", newJString(fields))
  add(query_598099, "pageToken", newJString(pageToken))
  add(query_598099, "quotaUser", newJString(quotaUser))
  add(query_598099, "alt", newJString(alt))
  add(query_598099, "oauth_token", newJString(oauthToken))
  add(path_598098, "accountId", newJString(accountId))
  add(query_598099, "userIp", newJString(userIp))
  add(query_598099, "maxResults", newJInt(maxResults))
  add(query_598099, "key", newJString(key))
  add(path_598098, "adClientId", newJString(adClientId))
  add(query_598099, "prettyPrint", newJBool(prettyPrint))
  result = call_598097.call(path_598098, query_598099, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_598082(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_598083,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsList_598084,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_598100 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsCustomchannelsGet_598102(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsGet_598101(path: JsonNode;
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
  var valid_598103 = path.getOrDefault("accountId")
  valid_598103 = validateParameter(valid_598103, JString, required = true,
                                 default = nil)
  if valid_598103 != nil:
    section.add "accountId", valid_598103
  var valid_598104 = path.getOrDefault("customChannelId")
  valid_598104 = validateParameter(valid_598104, JString, required = true,
                                 default = nil)
  if valid_598104 != nil:
    section.add "customChannelId", valid_598104
  var valid_598105 = path.getOrDefault("adClientId")
  valid_598105 = validateParameter(valid_598105, JString, required = true,
                                 default = nil)
  if valid_598105 != nil:
    section.add "adClientId", valid_598105
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598106 = query.getOrDefault("fields")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "fields", valid_598106
  var valid_598107 = query.getOrDefault("quotaUser")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "quotaUser", valid_598107
  var valid_598108 = query.getOrDefault("alt")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = newJString("json"))
  if valid_598108 != nil:
    section.add "alt", valid_598108
  var valid_598109 = query.getOrDefault("oauth_token")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = nil)
  if valid_598109 != nil:
    section.add "oauth_token", valid_598109
  var valid_598110 = query.getOrDefault("userIp")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "userIp", valid_598110
  var valid_598111 = query.getOrDefault("key")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "key", valid_598111
  var valid_598112 = query.getOrDefault("prettyPrint")
  valid_598112 = validateParameter(valid_598112, JBool, required = false,
                                 default = newJBool(true))
  if valid_598112 != nil:
    section.add "prettyPrint", valid_598112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598113: Call_AdsenseAccountsCustomchannelsGet_598100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_AdsenseAccountsCustomchannelsGet_598100;
          accountId: string; customChannelId: string; adClientId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(query_598116, "alt", newJString(alt))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(path_598115, "accountId", newJString(accountId))
  add(path_598115, "customChannelId", newJString(customChannelId))
  add(query_598116, "userIp", newJString(userIp))
  add(query_598116, "key", newJString(key))
  add(path_598115, "adClientId", newJString(adClientId))
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  result = call_598114.call(path_598115, query_598116, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_598100(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_598101,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsGet_598102,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_598117 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsCustomchannelsAdunitsList_598119(protocol: Scheme;
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

proc validate_AdsenseAccountsCustomchannelsAdunitsList_598118(path: JsonNode;
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
  var valid_598120 = path.getOrDefault("accountId")
  valid_598120 = validateParameter(valid_598120, JString, required = true,
                                 default = nil)
  if valid_598120 != nil:
    section.add "accountId", valid_598120
  var valid_598121 = path.getOrDefault("customChannelId")
  valid_598121 = validateParameter(valid_598121, JString, required = true,
                                 default = nil)
  if valid_598121 != nil:
    section.add "customChannelId", valid_598121
  var valid_598122 = path.getOrDefault("adClientId")
  valid_598122 = validateParameter(valid_598122, JString, required = true,
                                 default = nil)
  if valid_598122 != nil:
    section.add "adClientId", valid_598122
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598123 = query.getOrDefault("fields")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "fields", valid_598123
  var valid_598124 = query.getOrDefault("pageToken")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "pageToken", valid_598124
  var valid_598125 = query.getOrDefault("quotaUser")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "quotaUser", valid_598125
  var valid_598126 = query.getOrDefault("alt")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = newJString("json"))
  if valid_598126 != nil:
    section.add "alt", valid_598126
  var valid_598127 = query.getOrDefault("includeInactive")
  valid_598127 = validateParameter(valid_598127, JBool, required = false, default = nil)
  if valid_598127 != nil:
    section.add "includeInactive", valid_598127
  var valid_598128 = query.getOrDefault("oauth_token")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "oauth_token", valid_598128
  var valid_598129 = query.getOrDefault("userIp")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "userIp", valid_598129
  var valid_598130 = query.getOrDefault("maxResults")
  valid_598130 = validateParameter(valid_598130, JInt, required = false, default = nil)
  if valid_598130 != nil:
    section.add "maxResults", valid_598130
  var valid_598131 = query.getOrDefault("key")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "key", valid_598131
  var valid_598132 = query.getOrDefault("prettyPrint")
  valid_598132 = validateParameter(valid_598132, JBool, required = false,
                                 default = newJBool(true))
  if valid_598132 != nil:
    section.add "prettyPrint", valid_598132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598133: Call_AdsenseAccountsCustomchannelsAdunitsList_598117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_598133.validator(path, query, header, formData, body)
  let scheme = call_598133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598133.url(scheme.get, call_598133.host, call_598133.base,
                         call_598133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598133, url, valid)

proc call*(call_598134: Call_AdsenseAccountsCustomchannelsAdunitsList_598117;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598135 = newJObject()
  var query_598136 = newJObject()
  add(query_598136, "fields", newJString(fields))
  add(query_598136, "pageToken", newJString(pageToken))
  add(query_598136, "quotaUser", newJString(quotaUser))
  add(query_598136, "alt", newJString(alt))
  add(query_598136, "includeInactive", newJBool(includeInactive))
  add(query_598136, "oauth_token", newJString(oauthToken))
  add(path_598135, "accountId", newJString(accountId))
  add(path_598135, "customChannelId", newJString(customChannelId))
  add(query_598136, "userIp", newJString(userIp))
  add(query_598136, "maxResults", newJInt(maxResults))
  add(query_598136, "key", newJString(key))
  add(path_598135, "adClientId", newJString(adClientId))
  add(query_598136, "prettyPrint", newJBool(prettyPrint))
  result = call_598134.call(path_598135, query_598136, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_598117(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_598118,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsAdunitsList_598119,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_598137 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsUrlchannelsList_598139(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsUrlchannelsList_598138(path: JsonNode;
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
  var valid_598140 = path.getOrDefault("accountId")
  valid_598140 = validateParameter(valid_598140, JString, required = true,
                                 default = nil)
  if valid_598140 != nil:
    section.add "accountId", valid_598140
  var valid_598141 = path.getOrDefault("adClientId")
  valid_598141 = validateParameter(valid_598141, JString, required = true,
                                 default = nil)
  if valid_598141 != nil:
    section.add "adClientId", valid_598141
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598142 = query.getOrDefault("fields")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "fields", valid_598142
  var valid_598143 = query.getOrDefault("pageToken")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "pageToken", valid_598143
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
  var valid_598148 = query.getOrDefault("maxResults")
  valid_598148 = validateParameter(valid_598148, JInt, required = false, default = nil)
  if valid_598148 != nil:
    section.add "maxResults", valid_598148
  var valid_598149 = query.getOrDefault("key")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "key", valid_598149
  var valid_598150 = query.getOrDefault("prettyPrint")
  valid_598150 = validateParameter(valid_598150, JBool, required = false,
                                 default = newJBool(true))
  if valid_598150 != nil:
    section.add "prettyPrint", valid_598150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598151: Call_AdsenseAccountsUrlchannelsList_598137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_598151.validator(path, query, header, formData, body)
  let scheme = call_598151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598151.url(scheme.get, call_598151.host, call_598151.base,
                         call_598151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598151, url, valid)

proc call*(call_598152: Call_AdsenseAccountsUrlchannelsList_598137;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598153 = newJObject()
  var query_598154 = newJObject()
  add(query_598154, "fields", newJString(fields))
  add(query_598154, "pageToken", newJString(pageToken))
  add(query_598154, "quotaUser", newJString(quotaUser))
  add(query_598154, "alt", newJString(alt))
  add(query_598154, "oauth_token", newJString(oauthToken))
  add(path_598153, "accountId", newJString(accountId))
  add(query_598154, "userIp", newJString(userIp))
  add(query_598154, "maxResults", newJInt(maxResults))
  add(query_598154, "key", newJString(key))
  add(path_598153, "adClientId", newJString(adClientId))
  add(query_598154, "prettyPrint", newJBool(prettyPrint))
  result = call_598152.call(path_598153, query_598154, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_598137(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_598138,
    base: "/adsense/v1.3", url: url_AdsenseAccountsUrlchannelsList_598139,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_598155 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsAlertsList_598157(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAlertsList_598156(path: JsonNode; query: JsonNode;
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
  var valid_598158 = path.getOrDefault("accountId")
  valid_598158 = validateParameter(valid_598158, JString, required = true,
                                 default = nil)
  if valid_598158 != nil:
    section.add "accountId", valid_598158
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598159 = query.getOrDefault("locale")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "locale", valid_598159
  var valid_598160 = query.getOrDefault("fields")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "fields", valid_598160
  var valid_598161 = query.getOrDefault("quotaUser")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "quotaUser", valid_598161
  var valid_598162 = query.getOrDefault("alt")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = newJString("json"))
  if valid_598162 != nil:
    section.add "alt", valid_598162
  var valid_598163 = query.getOrDefault("oauth_token")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "oauth_token", valid_598163
  var valid_598164 = query.getOrDefault("userIp")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "userIp", valid_598164
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

proc call*(call_598167: Call_AdsenseAccountsAlertsList_598155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_598167.validator(path, query, header, formData, body)
  let scheme = call_598167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598167.url(scheme.get, call_598167.host, call_598167.base,
                         call_598167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598167, url, valid)

proc call*(call_598168: Call_AdsenseAccountsAlertsList_598155; accountId: string;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to retrieve the alerts.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598169 = newJObject()
  var query_598170 = newJObject()
  add(query_598170, "locale", newJString(locale))
  add(query_598170, "fields", newJString(fields))
  add(query_598170, "quotaUser", newJString(quotaUser))
  add(query_598170, "alt", newJString(alt))
  add(query_598170, "oauth_token", newJString(oauthToken))
  add(path_598169, "accountId", newJString(accountId))
  add(query_598170, "userIp", newJString(userIp))
  add(query_598170, "key", newJString(key))
  add(query_598170, "prettyPrint", newJBool(prettyPrint))
  result = call_598168.call(path_598169, query_598170, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_598155(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_598156, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAlertsList_598157, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_598171 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsReportsGenerate_598173(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsGenerate_598172(path: JsonNode;
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
  var valid_598174 = path.getOrDefault("accountId")
  valid_598174 = validateParameter(valid_598174, JString, required = true,
                                 default = nil)
  if valid_598174 != nil:
    section.add "accountId", valid_598174
  result.add "path", section
  ## parameters in `query` object:
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  var valid_598175 = query.getOrDefault("useTimezoneReporting")
  valid_598175 = validateParameter(valid_598175, JBool, required = false, default = nil)
  if valid_598175 != nil:
    section.add "useTimezoneReporting", valid_598175
  var valid_598176 = query.getOrDefault("locale")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = nil)
  if valid_598176 != nil:
    section.add "locale", valid_598176
  var valid_598177 = query.getOrDefault("fields")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "fields", valid_598177
  var valid_598178 = query.getOrDefault("quotaUser")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "quotaUser", valid_598178
  var valid_598179 = query.getOrDefault("alt")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = newJString("json"))
  if valid_598179 != nil:
    section.add "alt", valid_598179
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598180 = query.getOrDefault("endDate")
  valid_598180 = validateParameter(valid_598180, JString, required = true,
                                 default = nil)
  if valid_598180 != nil:
    section.add "endDate", valid_598180
  var valid_598181 = query.getOrDefault("currency")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "currency", valid_598181
  var valid_598182 = query.getOrDefault("startDate")
  valid_598182 = validateParameter(valid_598182, JString, required = true,
                                 default = nil)
  if valid_598182 != nil:
    section.add "startDate", valid_598182
  var valid_598183 = query.getOrDefault("sort")
  valid_598183 = validateParameter(valid_598183, JArray, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "sort", valid_598183
  var valid_598184 = query.getOrDefault("oauth_token")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "oauth_token", valid_598184
  var valid_598185 = query.getOrDefault("userIp")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "userIp", valid_598185
  var valid_598186 = query.getOrDefault("maxResults")
  valid_598186 = validateParameter(valid_598186, JInt, required = false, default = nil)
  if valid_598186 != nil:
    section.add "maxResults", valid_598186
  var valid_598187 = query.getOrDefault("key")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "key", valid_598187
  var valid_598188 = query.getOrDefault("metric")
  valid_598188 = validateParameter(valid_598188, JArray, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "metric", valid_598188
  var valid_598189 = query.getOrDefault("prettyPrint")
  valid_598189 = validateParameter(valid_598189, JBool, required = false,
                                 default = newJBool(true))
  if valid_598189 != nil:
    section.add "prettyPrint", valid_598189
  var valid_598190 = query.getOrDefault("dimension")
  valid_598190 = validateParameter(valid_598190, JArray, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "dimension", valid_598190
  var valid_598191 = query.getOrDefault("filter")
  valid_598191 = validateParameter(valid_598191, JArray, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "filter", valid_598191
  var valid_598192 = query.getOrDefault("startIndex")
  valid_598192 = validateParameter(valid_598192, JInt, required = false, default = nil)
  if valid_598192 != nil:
    section.add "startIndex", valid_598192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598193: Call_AdsenseAccountsReportsGenerate_598171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598193.validator(path, query, header, formData, body)
  let scheme = call_598193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598193.url(scheme.get, call_598193.host, call_598193.base,
                         call_598193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598193, url, valid)

proc call*(call_598194: Call_AdsenseAccountsReportsGenerate_598171;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  var path_598195 = newJObject()
  var query_598196 = newJObject()
  add(query_598196, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_598196, "locale", newJString(locale))
  add(query_598196, "fields", newJString(fields))
  add(query_598196, "quotaUser", newJString(quotaUser))
  add(query_598196, "alt", newJString(alt))
  add(query_598196, "endDate", newJString(endDate))
  add(query_598196, "currency", newJString(currency))
  add(query_598196, "startDate", newJString(startDate))
  if sort != nil:
    query_598196.add "sort", sort
  add(query_598196, "oauth_token", newJString(oauthToken))
  add(path_598195, "accountId", newJString(accountId))
  add(query_598196, "userIp", newJString(userIp))
  add(query_598196, "maxResults", newJInt(maxResults))
  add(query_598196, "key", newJString(key))
  if metric != nil:
    query_598196.add "metric", metric
  add(query_598196, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598196.add "dimension", dimension
  if filter != nil:
    query_598196.add "filter", filter
  add(query_598196, "startIndex", newJInt(startIndex))
  result = call_598194.call(path_598195, query_598196, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_598171(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_598172,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsGenerate_598173,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_598197 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsReportsSavedList_598199(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedList_598198(path: JsonNode;
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
  var valid_598200 = path.getOrDefault("accountId")
  valid_598200 = validateParameter(valid_598200, JString, required = true,
                                 default = nil)
  if valid_598200 != nil:
    section.add "accountId", valid_598200
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598201 = query.getOrDefault("fields")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "fields", valid_598201
  var valid_598202 = query.getOrDefault("pageToken")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "pageToken", valid_598202
  var valid_598203 = query.getOrDefault("quotaUser")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "quotaUser", valid_598203
  var valid_598204 = query.getOrDefault("alt")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = newJString("json"))
  if valid_598204 != nil:
    section.add "alt", valid_598204
  var valid_598205 = query.getOrDefault("oauth_token")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "oauth_token", valid_598205
  var valid_598206 = query.getOrDefault("userIp")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "userIp", valid_598206
  var valid_598207 = query.getOrDefault("maxResults")
  valid_598207 = validateParameter(valid_598207, JInt, required = false, default = nil)
  if valid_598207 != nil:
    section.add "maxResults", valid_598207
  var valid_598208 = query.getOrDefault("key")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "key", valid_598208
  var valid_598209 = query.getOrDefault("prettyPrint")
  valid_598209 = validateParameter(valid_598209, JBool, required = false,
                                 default = newJBool(true))
  if valid_598209 != nil:
    section.add "prettyPrint", valid_598209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598210: Call_AdsenseAccountsReportsSavedList_598197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_AdsenseAccountsReportsSavedList_598197;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  add(query_598213, "fields", newJString(fields))
  add(query_598213, "pageToken", newJString(pageToken))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(query_598213, "alt", newJString(alt))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(path_598212, "accountId", newJString(accountId))
  add(query_598213, "userIp", newJString(userIp))
  add(query_598213, "maxResults", newJInt(maxResults))
  add(query_598213, "key", newJString(key))
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  result = call_598211.call(path_598212, query_598213, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_598197(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_598198,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedList_598199,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_598214 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsReportsSavedGenerate_598216(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedGenerate_598215(path: JsonNode;
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
  var valid_598217 = path.getOrDefault("accountId")
  valid_598217 = validateParameter(valid_598217, JString, required = true,
                                 default = nil)
  if valid_598217 != nil:
    section.add "accountId", valid_598217
  var valid_598218 = path.getOrDefault("savedReportId")
  valid_598218 = validateParameter(valid_598218, JString, required = true,
                                 default = nil)
  if valid_598218 != nil:
    section.add "savedReportId", valid_598218
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_598219 = query.getOrDefault("locale")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "locale", valid_598219
  var valid_598220 = query.getOrDefault("fields")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "fields", valid_598220
  var valid_598221 = query.getOrDefault("quotaUser")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "quotaUser", valid_598221
  var valid_598222 = query.getOrDefault("alt")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = newJString("json"))
  if valid_598222 != nil:
    section.add "alt", valid_598222
  var valid_598223 = query.getOrDefault("oauth_token")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "oauth_token", valid_598223
  var valid_598224 = query.getOrDefault("userIp")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "userIp", valid_598224
  var valid_598225 = query.getOrDefault("maxResults")
  valid_598225 = validateParameter(valid_598225, JInt, required = false, default = nil)
  if valid_598225 != nil:
    section.add "maxResults", valid_598225
  var valid_598226 = query.getOrDefault("key")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "key", valid_598226
  var valid_598227 = query.getOrDefault("prettyPrint")
  valid_598227 = validateParameter(valid_598227, JBool, required = false,
                                 default = newJBool(true))
  if valid_598227 != nil:
    section.add "prettyPrint", valid_598227
  var valid_598228 = query.getOrDefault("startIndex")
  valid_598228 = validateParameter(valid_598228, JInt, required = false, default = nil)
  if valid_598228 != nil:
    section.add "startIndex", valid_598228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598229: Call_AdsenseAccountsReportsSavedGenerate_598214;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598229.validator(path, query, header, formData, body)
  let scheme = call_598229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598229.url(scheme.get, call_598229.host, call_598229.base,
                         call_598229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598229, url, valid)

proc call*(call_598230: Call_AdsenseAccountsReportsSavedGenerate_598214;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_598231 = newJObject()
  var query_598232 = newJObject()
  add(query_598232, "locale", newJString(locale))
  add(query_598232, "fields", newJString(fields))
  add(query_598232, "quotaUser", newJString(quotaUser))
  add(query_598232, "alt", newJString(alt))
  add(query_598232, "oauth_token", newJString(oauthToken))
  add(path_598231, "accountId", newJString(accountId))
  add(query_598232, "userIp", newJString(userIp))
  add(path_598231, "savedReportId", newJString(savedReportId))
  add(query_598232, "maxResults", newJInt(maxResults))
  add(query_598232, "key", newJString(key))
  add(query_598232, "prettyPrint", newJBool(prettyPrint))
  add(query_598232, "startIndex", newJInt(startIndex))
  result = call_598230.call(path_598231, query_598232, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_598214(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_598215,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedGenerate_598216,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_598233 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsSavedadstylesList_598235(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesList_598234(path: JsonNode;
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
  var valid_598236 = path.getOrDefault("accountId")
  valid_598236 = validateParameter(valid_598236, JString, required = true,
                                 default = nil)
  if valid_598236 != nil:
    section.add "accountId", valid_598236
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598237 = query.getOrDefault("fields")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = nil)
  if valid_598237 != nil:
    section.add "fields", valid_598237
  var valid_598238 = query.getOrDefault("pageToken")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "pageToken", valid_598238
  var valid_598239 = query.getOrDefault("quotaUser")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "quotaUser", valid_598239
  var valid_598240 = query.getOrDefault("alt")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = newJString("json"))
  if valid_598240 != nil:
    section.add "alt", valid_598240
  var valid_598241 = query.getOrDefault("oauth_token")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "oauth_token", valid_598241
  var valid_598242 = query.getOrDefault("userIp")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "userIp", valid_598242
  var valid_598243 = query.getOrDefault("maxResults")
  valid_598243 = validateParameter(valid_598243, JInt, required = false, default = nil)
  if valid_598243 != nil:
    section.add "maxResults", valid_598243
  var valid_598244 = query.getOrDefault("key")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "key", valid_598244
  var valid_598245 = query.getOrDefault("prettyPrint")
  valid_598245 = validateParameter(valid_598245, JBool, required = false,
                                 default = newJBool(true))
  if valid_598245 != nil:
    section.add "prettyPrint", valid_598245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598246: Call_AdsenseAccountsSavedadstylesList_598233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_598246.validator(path, query, header, formData, body)
  let scheme = call_598246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598246.url(scheme.get, call_598246.host, call_598246.base,
                         call_598246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598246, url, valid)

proc call*(call_598247: Call_AdsenseAccountsSavedadstylesList_598233;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to list saved ad styles.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598248 = newJObject()
  var query_598249 = newJObject()
  add(query_598249, "fields", newJString(fields))
  add(query_598249, "pageToken", newJString(pageToken))
  add(query_598249, "quotaUser", newJString(quotaUser))
  add(query_598249, "alt", newJString(alt))
  add(query_598249, "oauth_token", newJString(oauthToken))
  add(path_598248, "accountId", newJString(accountId))
  add(query_598249, "userIp", newJString(userIp))
  add(query_598249, "maxResults", newJInt(maxResults))
  add(query_598249, "key", newJString(key))
  add(query_598249, "prettyPrint", newJBool(prettyPrint))
  result = call_598247.call(path_598248, query_598249, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_598233(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_598234,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesList_598235,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_598250 = ref object of OpenApiRestCall_597424
proc url_AdsenseAccountsSavedadstylesGet_598252(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesGet_598251(path: JsonNode;
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
  var valid_598253 = path.getOrDefault("accountId")
  valid_598253 = validateParameter(valid_598253, JString, required = true,
                                 default = nil)
  if valid_598253 != nil:
    section.add "accountId", valid_598253
  var valid_598254 = path.getOrDefault("savedAdStyleId")
  valid_598254 = validateParameter(valid_598254, JString, required = true,
                                 default = nil)
  if valid_598254 != nil:
    section.add "savedAdStyleId", valid_598254
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598255 = query.getOrDefault("fields")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "fields", valid_598255
  var valid_598256 = query.getOrDefault("quotaUser")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "quotaUser", valid_598256
  var valid_598257 = query.getOrDefault("alt")
  valid_598257 = validateParameter(valid_598257, JString, required = false,
                                 default = newJString("json"))
  if valid_598257 != nil:
    section.add "alt", valid_598257
  var valid_598258 = query.getOrDefault("oauth_token")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "oauth_token", valid_598258
  var valid_598259 = query.getOrDefault("userIp")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "userIp", valid_598259
  var valid_598260 = query.getOrDefault("key")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "key", valid_598260
  var valid_598261 = query.getOrDefault("prettyPrint")
  valid_598261 = validateParameter(valid_598261, JBool, required = false,
                                 default = newJBool(true))
  if valid_598261 != nil:
    section.add "prettyPrint", valid_598261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598262: Call_AdsenseAccountsSavedadstylesGet_598250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_598262.validator(path, query, header, formData, body)
  let scheme = call_598262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598262.url(scheme.get, call_598262.host, call_598262.base,
                         call_598262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598262, url, valid)

proc call*(call_598263: Call_AdsenseAccountsSavedadstylesGet_598250;
          accountId: string; savedAdStyleId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAccountsSavedadstylesGet
  ## List a specific saved ad style for the specified account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account for which to get the saved ad style.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598264 = newJObject()
  var query_598265 = newJObject()
  add(query_598265, "fields", newJString(fields))
  add(query_598265, "quotaUser", newJString(quotaUser))
  add(query_598265, "alt", newJString(alt))
  add(query_598265, "oauth_token", newJString(oauthToken))
  add(path_598264, "accountId", newJString(accountId))
  add(path_598264, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_598265, "userIp", newJString(userIp))
  add(query_598265, "key", newJString(key))
  add(query_598265, "prettyPrint", newJBool(prettyPrint))
  result = call_598263.call(path_598264, query_598265, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_598250(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_598251,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesGet_598252,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_598266 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdclientsList_598268(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_598267(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598269 = query.getOrDefault("fields")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "fields", valid_598269
  var valid_598270 = query.getOrDefault("pageToken")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "pageToken", valid_598270
  var valid_598271 = query.getOrDefault("quotaUser")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "quotaUser", valid_598271
  var valid_598272 = query.getOrDefault("alt")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = newJString("json"))
  if valid_598272 != nil:
    section.add "alt", valid_598272
  var valid_598273 = query.getOrDefault("oauth_token")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "oauth_token", valid_598273
  var valid_598274 = query.getOrDefault("userIp")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "userIp", valid_598274
  var valid_598275 = query.getOrDefault("maxResults")
  valid_598275 = validateParameter(valid_598275, JInt, required = false, default = nil)
  if valid_598275 != nil:
    section.add "maxResults", valid_598275
  var valid_598276 = query.getOrDefault("key")
  valid_598276 = validateParameter(valid_598276, JString, required = false,
                                 default = nil)
  if valid_598276 != nil:
    section.add "key", valid_598276
  var valid_598277 = query.getOrDefault("prettyPrint")
  valid_598277 = validateParameter(valid_598277, JBool, required = false,
                                 default = newJBool(true))
  if valid_598277 != nil:
    section.add "prettyPrint", valid_598277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598278: Call_AdsenseAdclientsList_598266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_598278.validator(path, query, header, formData, body)
  let scheme = call_598278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598278.url(scheme.get, call_598278.host, call_598278.base,
                         call_598278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598278, url, valid)

proc call*(call_598279: Call_AdsenseAdclientsList_598266; fields: string = "";
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598280 = newJObject()
  add(query_598280, "fields", newJString(fields))
  add(query_598280, "pageToken", newJString(pageToken))
  add(query_598280, "quotaUser", newJString(quotaUser))
  add(query_598280, "alt", newJString(alt))
  add(query_598280, "oauth_token", newJString(oauthToken))
  add(query_598280, "userIp", newJString(userIp))
  add(query_598280, "maxResults", newJInt(maxResults))
  add(query_598280, "key", newJString(key))
  add(query_598280, "prettyPrint", newJBool(prettyPrint))
  result = call_598279.call(nil, query_598280, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_598266(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_598267, base: "/adsense/v1.3",
    url: url_AdsenseAdclientsList_598268, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_598281 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsList_598283(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsList_598282(path: JsonNode; query: JsonNode;
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
  var valid_598284 = path.getOrDefault("adClientId")
  valid_598284 = validateParameter(valid_598284, JString, required = true,
                                 default = nil)
  if valid_598284 != nil:
    section.add "adClientId", valid_598284
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598285 = query.getOrDefault("fields")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "fields", valid_598285
  var valid_598286 = query.getOrDefault("pageToken")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "pageToken", valid_598286
  var valid_598287 = query.getOrDefault("quotaUser")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "quotaUser", valid_598287
  var valid_598288 = query.getOrDefault("alt")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = newJString("json"))
  if valid_598288 != nil:
    section.add "alt", valid_598288
  var valid_598289 = query.getOrDefault("includeInactive")
  valid_598289 = validateParameter(valid_598289, JBool, required = false, default = nil)
  if valid_598289 != nil:
    section.add "includeInactive", valid_598289
  var valid_598290 = query.getOrDefault("oauth_token")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "oauth_token", valid_598290
  var valid_598291 = query.getOrDefault("userIp")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "userIp", valid_598291
  var valid_598292 = query.getOrDefault("maxResults")
  valid_598292 = validateParameter(valid_598292, JInt, required = false, default = nil)
  if valid_598292 != nil:
    section.add "maxResults", valid_598292
  var valid_598293 = query.getOrDefault("key")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "key", valid_598293
  var valid_598294 = query.getOrDefault("prettyPrint")
  valid_598294 = validateParameter(valid_598294, JBool, required = false,
                                 default = newJBool(true))
  if valid_598294 != nil:
    section.add "prettyPrint", valid_598294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598295: Call_AdsenseAdunitsList_598281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_598295.validator(path, query, header, formData, body)
  let scheme = call_598295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598295.url(scheme.get, call_598295.host, call_598295.base,
                         call_598295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598295, url, valid)

proc call*(call_598296: Call_AdsenseAdunitsList_598281; adClientId: string;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598297 = newJObject()
  var query_598298 = newJObject()
  add(query_598298, "fields", newJString(fields))
  add(query_598298, "pageToken", newJString(pageToken))
  add(query_598298, "quotaUser", newJString(quotaUser))
  add(query_598298, "alt", newJString(alt))
  add(query_598298, "includeInactive", newJBool(includeInactive))
  add(query_598298, "oauth_token", newJString(oauthToken))
  add(query_598298, "userIp", newJString(userIp))
  add(query_598298, "maxResults", newJInt(maxResults))
  add(query_598298, "key", newJString(key))
  add(path_598297, "adClientId", newJString(adClientId))
  add(query_598298, "prettyPrint", newJBool(prettyPrint))
  result = call_598296.call(path_598297, query_598298, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_598281(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_598282, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsList_598283, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_598299 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsGet_598301(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGet_598300(path: JsonNode; query: JsonNode;
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
  var valid_598302 = path.getOrDefault("adClientId")
  valid_598302 = validateParameter(valid_598302, JString, required = true,
                                 default = nil)
  if valid_598302 != nil:
    section.add "adClientId", valid_598302
  var valid_598303 = path.getOrDefault("adUnitId")
  valid_598303 = validateParameter(valid_598303, JString, required = true,
                                 default = nil)
  if valid_598303 != nil:
    section.add "adUnitId", valid_598303
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598304 = query.getOrDefault("fields")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "fields", valid_598304
  var valid_598305 = query.getOrDefault("quotaUser")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "quotaUser", valid_598305
  var valid_598306 = query.getOrDefault("alt")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = newJString("json"))
  if valid_598306 != nil:
    section.add "alt", valid_598306
  var valid_598307 = query.getOrDefault("oauth_token")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "oauth_token", valid_598307
  var valid_598308 = query.getOrDefault("userIp")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "userIp", valid_598308
  var valid_598309 = query.getOrDefault("key")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "key", valid_598309
  var valid_598310 = query.getOrDefault("prettyPrint")
  valid_598310 = validateParameter(valid_598310, JBool, required = false,
                                 default = newJBool(true))
  if valid_598310 != nil:
    section.add "prettyPrint", valid_598310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598311: Call_AdsenseAdunitsGet_598299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_598311.validator(path, query, header, formData, body)
  let scheme = call_598311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598311.url(scheme.get, call_598311.host, call_598311.base,
                         call_598311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598311, url, valid)

proc call*(call_598312: Call_AdsenseAdunitsGet_598299; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsGet
  ## Gets the specified ad unit in the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598313 = newJObject()
  var query_598314 = newJObject()
  add(query_598314, "fields", newJString(fields))
  add(query_598314, "quotaUser", newJString(quotaUser))
  add(query_598314, "alt", newJString(alt))
  add(query_598314, "oauth_token", newJString(oauthToken))
  add(query_598314, "userIp", newJString(userIp))
  add(query_598314, "key", newJString(key))
  add(path_598313, "adClientId", newJString(adClientId))
  add(path_598313, "adUnitId", newJString(adUnitId))
  add(query_598314, "prettyPrint", newJBool(prettyPrint))
  result = call_598312.call(path_598313, query_598314, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_598299(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_598300, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGet_598301, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_598315 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsGetAdCode_598317(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGetAdCode_598316(path: JsonNode; query: JsonNode;
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
  var valid_598318 = path.getOrDefault("adClientId")
  valid_598318 = validateParameter(valid_598318, JString, required = true,
                                 default = nil)
  if valid_598318 != nil:
    section.add "adClientId", valid_598318
  var valid_598319 = path.getOrDefault("adUnitId")
  valid_598319 = validateParameter(valid_598319, JString, required = true,
                                 default = nil)
  if valid_598319 != nil:
    section.add "adUnitId", valid_598319
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598320 = query.getOrDefault("fields")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "fields", valid_598320
  var valid_598321 = query.getOrDefault("quotaUser")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "quotaUser", valid_598321
  var valid_598322 = query.getOrDefault("alt")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = newJString("json"))
  if valid_598322 != nil:
    section.add "alt", valid_598322
  var valid_598323 = query.getOrDefault("oauth_token")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "oauth_token", valid_598323
  var valid_598324 = query.getOrDefault("userIp")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "userIp", valid_598324
  var valid_598325 = query.getOrDefault("key")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "key", valid_598325
  var valid_598326 = query.getOrDefault("prettyPrint")
  valid_598326 = validateParameter(valid_598326, JBool, required = false,
                                 default = newJBool(true))
  if valid_598326 != nil:
    section.add "prettyPrint", valid_598326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598327: Call_AdsenseAdunitsGetAdCode_598315; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_598327.validator(path, query, header, formData, body)
  let scheme = call_598327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598327.url(scheme.get, call_598327.host, call_598327.base,
                         call_598327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598327, url, valid)

proc call*(call_598328: Call_AdsenseAdunitsGetAdCode_598315; adClientId: string;
          adUnitId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598329 = newJObject()
  var query_598330 = newJObject()
  add(query_598330, "fields", newJString(fields))
  add(query_598330, "quotaUser", newJString(quotaUser))
  add(query_598330, "alt", newJString(alt))
  add(query_598330, "oauth_token", newJString(oauthToken))
  add(query_598330, "userIp", newJString(userIp))
  add(query_598330, "key", newJString(key))
  add(path_598329, "adClientId", newJString(adClientId))
  add(path_598329, "adUnitId", newJString(adUnitId))
  add(query_598330, "prettyPrint", newJBool(prettyPrint))
  result = call_598328.call(path_598329, query_598330, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_598315(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_598316, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGetAdCode_598317, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_598331 = ref object of OpenApiRestCall_597424
proc url_AdsenseAdunitsCustomchannelsList_598333(protocol: Scheme; host: string;
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

proc validate_AdsenseAdunitsCustomchannelsList_598332(path: JsonNode;
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
  var valid_598334 = path.getOrDefault("adClientId")
  valid_598334 = validateParameter(valid_598334, JString, required = true,
                                 default = nil)
  if valid_598334 != nil:
    section.add "adClientId", valid_598334
  var valid_598335 = path.getOrDefault("adUnitId")
  valid_598335 = validateParameter(valid_598335, JString, required = true,
                                 default = nil)
  if valid_598335 != nil:
    section.add "adUnitId", valid_598335
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598336 = query.getOrDefault("fields")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "fields", valid_598336
  var valid_598337 = query.getOrDefault("pageToken")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "pageToken", valid_598337
  var valid_598338 = query.getOrDefault("quotaUser")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "quotaUser", valid_598338
  var valid_598339 = query.getOrDefault("alt")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = newJString("json"))
  if valid_598339 != nil:
    section.add "alt", valid_598339
  var valid_598340 = query.getOrDefault("oauth_token")
  valid_598340 = validateParameter(valid_598340, JString, required = false,
                                 default = nil)
  if valid_598340 != nil:
    section.add "oauth_token", valid_598340
  var valid_598341 = query.getOrDefault("userIp")
  valid_598341 = validateParameter(valid_598341, JString, required = false,
                                 default = nil)
  if valid_598341 != nil:
    section.add "userIp", valid_598341
  var valid_598342 = query.getOrDefault("maxResults")
  valid_598342 = validateParameter(valid_598342, JInt, required = false, default = nil)
  if valid_598342 != nil:
    section.add "maxResults", valid_598342
  var valid_598343 = query.getOrDefault("key")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "key", valid_598343
  var valid_598344 = query.getOrDefault("prettyPrint")
  valid_598344 = validateParameter(valid_598344, JBool, required = false,
                                 default = newJBool(true))
  if valid_598344 != nil:
    section.add "prettyPrint", valid_598344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598345: Call_AdsenseAdunitsCustomchannelsList_598331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_598345.validator(path, query, header, formData, body)
  let scheme = call_598345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598345.url(scheme.get, call_598345.host, call_598345.base,
                         call_598345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598345, url, valid)

proc call*(call_598346: Call_AdsenseAdunitsCustomchannelsList_598331;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  var path_598347 = newJObject()
  var query_598348 = newJObject()
  add(query_598348, "fields", newJString(fields))
  add(query_598348, "pageToken", newJString(pageToken))
  add(query_598348, "quotaUser", newJString(quotaUser))
  add(query_598348, "alt", newJString(alt))
  add(query_598348, "oauth_token", newJString(oauthToken))
  add(query_598348, "userIp", newJString(userIp))
  add(query_598348, "maxResults", newJInt(maxResults))
  add(query_598348, "key", newJString(key))
  add(path_598347, "adClientId", newJString(adClientId))
  add(path_598347, "adUnitId", newJString(adUnitId))
  add(query_598348, "prettyPrint", newJBool(prettyPrint))
  result = call_598346.call(path_598347, query_598348, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_598331(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_598332,
    base: "/adsense/v1.3", url: url_AdsenseAdunitsCustomchannelsList_598333,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_598349 = ref object of OpenApiRestCall_597424
proc url_AdsenseCustomchannelsList_598351(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsList_598350(path: JsonNode; query: JsonNode;
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
  var valid_598352 = path.getOrDefault("adClientId")
  valid_598352 = validateParameter(valid_598352, JString, required = true,
                                 default = nil)
  if valid_598352 != nil:
    section.add "adClientId", valid_598352
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598353 = query.getOrDefault("fields")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "fields", valid_598353
  var valid_598354 = query.getOrDefault("pageToken")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "pageToken", valid_598354
  var valid_598355 = query.getOrDefault("quotaUser")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "quotaUser", valid_598355
  var valid_598356 = query.getOrDefault("alt")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = newJString("json"))
  if valid_598356 != nil:
    section.add "alt", valid_598356
  var valid_598357 = query.getOrDefault("oauth_token")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "oauth_token", valid_598357
  var valid_598358 = query.getOrDefault("userIp")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "userIp", valid_598358
  var valid_598359 = query.getOrDefault("maxResults")
  valid_598359 = validateParameter(valid_598359, JInt, required = false, default = nil)
  if valid_598359 != nil:
    section.add "maxResults", valid_598359
  var valid_598360 = query.getOrDefault("key")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = nil)
  if valid_598360 != nil:
    section.add "key", valid_598360
  var valid_598361 = query.getOrDefault("prettyPrint")
  valid_598361 = validateParameter(valid_598361, JBool, required = false,
                                 default = newJBool(true))
  if valid_598361 != nil:
    section.add "prettyPrint", valid_598361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598362: Call_AdsenseCustomchannelsList_598349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_598362.validator(path, query, header, formData, body)
  let scheme = call_598362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598362.url(scheme.get, call_598362.host, call_598362.base,
                         call_598362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598362, url, valid)

proc call*(call_598363: Call_AdsenseCustomchannelsList_598349; adClientId: string;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598364 = newJObject()
  var query_598365 = newJObject()
  add(query_598365, "fields", newJString(fields))
  add(query_598365, "pageToken", newJString(pageToken))
  add(query_598365, "quotaUser", newJString(quotaUser))
  add(query_598365, "alt", newJString(alt))
  add(query_598365, "oauth_token", newJString(oauthToken))
  add(query_598365, "userIp", newJString(userIp))
  add(query_598365, "maxResults", newJInt(maxResults))
  add(query_598365, "key", newJString(key))
  add(path_598364, "adClientId", newJString(adClientId))
  add(query_598365, "prettyPrint", newJBool(prettyPrint))
  result = call_598363.call(path_598364, query_598365, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_598349(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_598350, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsList_598351, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_598366 = ref object of OpenApiRestCall_597424
proc url_AdsenseCustomchannelsGet_598368(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsGet_598367(path: JsonNode; query: JsonNode;
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
  var valid_598369 = path.getOrDefault("customChannelId")
  valid_598369 = validateParameter(valid_598369, JString, required = true,
                                 default = nil)
  if valid_598369 != nil:
    section.add "customChannelId", valid_598369
  var valid_598370 = path.getOrDefault("adClientId")
  valid_598370 = validateParameter(valid_598370, JString, required = true,
                                 default = nil)
  if valid_598370 != nil:
    section.add "adClientId", valid_598370
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598371 = query.getOrDefault("fields")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "fields", valid_598371
  var valid_598372 = query.getOrDefault("quotaUser")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "quotaUser", valid_598372
  var valid_598373 = query.getOrDefault("alt")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = newJString("json"))
  if valid_598373 != nil:
    section.add "alt", valid_598373
  var valid_598374 = query.getOrDefault("oauth_token")
  valid_598374 = validateParameter(valid_598374, JString, required = false,
                                 default = nil)
  if valid_598374 != nil:
    section.add "oauth_token", valid_598374
  var valid_598375 = query.getOrDefault("userIp")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "userIp", valid_598375
  var valid_598376 = query.getOrDefault("key")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "key", valid_598376
  var valid_598377 = query.getOrDefault("prettyPrint")
  valid_598377 = validateParameter(valid_598377, JBool, required = false,
                                 default = newJBool(true))
  if valid_598377 != nil:
    section.add "prettyPrint", valid_598377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598378: Call_AdsenseCustomchannelsGet_598366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_598378.validator(path, query, header, formData, body)
  let scheme = call_598378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598378.url(scheme.get, call_598378.host, call_598378.base,
                         call_598378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598378, url, valid)

proc call*(call_598379: Call_AdsenseCustomchannelsGet_598366;
          customChannelId: string; adClientId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598380 = newJObject()
  var query_598381 = newJObject()
  add(query_598381, "fields", newJString(fields))
  add(query_598381, "quotaUser", newJString(quotaUser))
  add(query_598381, "alt", newJString(alt))
  add(query_598381, "oauth_token", newJString(oauthToken))
  add(path_598380, "customChannelId", newJString(customChannelId))
  add(query_598381, "userIp", newJString(userIp))
  add(query_598381, "key", newJString(key))
  add(path_598380, "adClientId", newJString(adClientId))
  add(query_598381, "prettyPrint", newJBool(prettyPrint))
  result = call_598379.call(path_598380, query_598381, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_598366(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_598367, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsGet_598368, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_598382 = ref object of OpenApiRestCall_597424
proc url_AdsenseCustomchannelsAdunitsList_598384(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsAdunitsList_598383(path: JsonNode;
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
  var valid_598385 = path.getOrDefault("customChannelId")
  valid_598385 = validateParameter(valid_598385, JString, required = true,
                                 default = nil)
  if valid_598385 != nil:
    section.add "customChannelId", valid_598385
  var valid_598386 = path.getOrDefault("adClientId")
  valid_598386 = validateParameter(valid_598386, JString, required = true,
                                 default = nil)
  if valid_598386 != nil:
    section.add "adClientId", valid_598386
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598387 = query.getOrDefault("fields")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "fields", valid_598387
  var valid_598388 = query.getOrDefault("pageToken")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "pageToken", valid_598388
  var valid_598389 = query.getOrDefault("quotaUser")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "quotaUser", valid_598389
  var valid_598390 = query.getOrDefault("alt")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = newJString("json"))
  if valid_598390 != nil:
    section.add "alt", valid_598390
  var valid_598391 = query.getOrDefault("includeInactive")
  valid_598391 = validateParameter(valid_598391, JBool, required = false, default = nil)
  if valid_598391 != nil:
    section.add "includeInactive", valid_598391
  var valid_598392 = query.getOrDefault("oauth_token")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "oauth_token", valid_598392
  var valid_598393 = query.getOrDefault("userIp")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "userIp", valid_598393
  var valid_598394 = query.getOrDefault("maxResults")
  valid_598394 = validateParameter(valid_598394, JInt, required = false, default = nil)
  if valid_598394 != nil:
    section.add "maxResults", valid_598394
  var valid_598395 = query.getOrDefault("key")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "key", valid_598395
  var valid_598396 = query.getOrDefault("prettyPrint")
  valid_598396 = validateParameter(valid_598396, JBool, required = false,
                                 default = newJBool(true))
  if valid_598396 != nil:
    section.add "prettyPrint", valid_598396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598397: Call_AdsenseCustomchannelsAdunitsList_598382;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_598397.validator(path, query, header, formData, body)
  let scheme = call_598397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598397.url(scheme.get, call_598397.host, call_598397.base,
                         call_598397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598397, url, valid)

proc call*(call_598398: Call_AdsenseCustomchannelsAdunitsList_598382;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598399 = newJObject()
  var query_598400 = newJObject()
  add(query_598400, "fields", newJString(fields))
  add(query_598400, "pageToken", newJString(pageToken))
  add(query_598400, "quotaUser", newJString(quotaUser))
  add(query_598400, "alt", newJString(alt))
  add(query_598400, "includeInactive", newJBool(includeInactive))
  add(query_598400, "oauth_token", newJString(oauthToken))
  add(path_598399, "customChannelId", newJString(customChannelId))
  add(query_598400, "userIp", newJString(userIp))
  add(query_598400, "maxResults", newJInt(maxResults))
  add(query_598400, "key", newJString(key))
  add(path_598399, "adClientId", newJString(adClientId))
  add(query_598400, "prettyPrint", newJBool(prettyPrint))
  result = call_598398.call(path_598399, query_598400, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_598382(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_598383,
    base: "/adsense/v1.3", url: url_AdsenseCustomchannelsAdunitsList_598384,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_598401 = ref object of OpenApiRestCall_597424
proc url_AdsenseUrlchannelsList_598403(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseUrlchannelsList_598402(path: JsonNode; query: JsonNode;
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
  var valid_598404 = path.getOrDefault("adClientId")
  valid_598404 = validateParameter(valid_598404, JString, required = true,
                                 default = nil)
  if valid_598404 != nil:
    section.add "adClientId", valid_598404
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598405 = query.getOrDefault("fields")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "fields", valid_598405
  var valid_598406 = query.getOrDefault("pageToken")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "pageToken", valid_598406
  var valid_598407 = query.getOrDefault("quotaUser")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "quotaUser", valid_598407
  var valid_598408 = query.getOrDefault("alt")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = newJString("json"))
  if valid_598408 != nil:
    section.add "alt", valid_598408
  var valid_598409 = query.getOrDefault("oauth_token")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "oauth_token", valid_598409
  var valid_598410 = query.getOrDefault("userIp")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "userIp", valid_598410
  var valid_598411 = query.getOrDefault("maxResults")
  valid_598411 = validateParameter(valid_598411, JInt, required = false, default = nil)
  if valid_598411 != nil:
    section.add "maxResults", valid_598411
  var valid_598412 = query.getOrDefault("key")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "key", valid_598412
  var valid_598413 = query.getOrDefault("prettyPrint")
  valid_598413 = validateParameter(valid_598413, JBool, required = false,
                                 default = newJBool(true))
  if valid_598413 != nil:
    section.add "prettyPrint", valid_598413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598414: Call_AdsenseUrlchannelsList_598401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_598414.validator(path, query, header, formData, body)
  let scheme = call_598414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598414.url(scheme.get, call_598414.host, call_598414.base,
                         call_598414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598414, url, valid)

proc call*(call_598415: Call_AdsenseUrlchannelsList_598401; adClientId: string;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598416 = newJObject()
  var query_598417 = newJObject()
  add(query_598417, "fields", newJString(fields))
  add(query_598417, "pageToken", newJString(pageToken))
  add(query_598417, "quotaUser", newJString(quotaUser))
  add(query_598417, "alt", newJString(alt))
  add(query_598417, "oauth_token", newJString(oauthToken))
  add(query_598417, "userIp", newJString(userIp))
  add(query_598417, "maxResults", newJInt(maxResults))
  add(query_598417, "key", newJString(key))
  add(path_598416, "adClientId", newJString(adClientId))
  add(query_598417, "prettyPrint", newJBool(prettyPrint))
  result = call_598415.call(path_598416, query_598417, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_598401(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_598402, base: "/adsense/v1.3",
    url: url_AdsenseUrlchannelsList_598403, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_598418 = ref object of OpenApiRestCall_597424
proc url_AdsenseAlertsList_598420(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_598419(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598421 = query.getOrDefault("locale")
  valid_598421 = validateParameter(valid_598421, JString, required = false,
                                 default = nil)
  if valid_598421 != nil:
    section.add "locale", valid_598421
  var valid_598422 = query.getOrDefault("fields")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = nil)
  if valid_598422 != nil:
    section.add "fields", valid_598422
  var valid_598423 = query.getOrDefault("quotaUser")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "quotaUser", valid_598423
  var valid_598424 = query.getOrDefault("alt")
  valid_598424 = validateParameter(valid_598424, JString, required = false,
                                 default = newJString("json"))
  if valid_598424 != nil:
    section.add "alt", valid_598424
  var valid_598425 = query.getOrDefault("oauth_token")
  valid_598425 = validateParameter(valid_598425, JString, required = false,
                                 default = nil)
  if valid_598425 != nil:
    section.add "oauth_token", valid_598425
  var valid_598426 = query.getOrDefault("userIp")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = nil)
  if valid_598426 != nil:
    section.add "userIp", valid_598426
  var valid_598427 = query.getOrDefault("key")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "key", valid_598427
  var valid_598428 = query.getOrDefault("prettyPrint")
  valid_598428 = validateParameter(valid_598428, JBool, required = false,
                                 default = newJBool(true))
  if valid_598428 != nil:
    section.add "prettyPrint", valid_598428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598429: Call_AdsenseAlertsList_598418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_598429.validator(path, query, header, formData, body)
  let scheme = call_598429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598429.url(scheme.get, call_598429.host, call_598429.base,
                         call_598429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598429, url, valid)

proc call*(call_598430: Call_AdsenseAlertsList_598418; locale: string = "";
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598431 = newJObject()
  add(query_598431, "locale", newJString(locale))
  add(query_598431, "fields", newJString(fields))
  add(query_598431, "quotaUser", newJString(quotaUser))
  add(query_598431, "alt", newJString(alt))
  add(query_598431, "oauth_token", newJString(oauthToken))
  add(query_598431, "userIp", newJString(userIp))
  add(query_598431, "key", newJString(key))
  add(query_598431, "prettyPrint", newJBool(prettyPrint))
  result = call_598430.call(nil, query_598431, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_598418(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_598419, base: "/adsense/v1.3",
    url: url_AdsenseAlertsList_598420, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_598432 = ref object of OpenApiRestCall_597424
proc url_AdsenseMetadataDimensionsList_598434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_598433(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598435 = query.getOrDefault("fields")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "fields", valid_598435
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
  var valid_598438 = query.getOrDefault("oauth_token")
  valid_598438 = validateParameter(valid_598438, JString, required = false,
                                 default = nil)
  if valid_598438 != nil:
    section.add "oauth_token", valid_598438
  var valid_598439 = query.getOrDefault("userIp")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = nil)
  if valid_598439 != nil:
    section.add "userIp", valid_598439
  var valid_598440 = query.getOrDefault("key")
  valid_598440 = validateParameter(valid_598440, JString, required = false,
                                 default = nil)
  if valid_598440 != nil:
    section.add "key", valid_598440
  var valid_598441 = query.getOrDefault("prettyPrint")
  valid_598441 = validateParameter(valid_598441, JBool, required = false,
                                 default = newJBool(true))
  if valid_598441 != nil:
    section.add "prettyPrint", valid_598441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598442: Call_AdsenseMetadataDimensionsList_598432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_598442.validator(path, query, header, formData, body)
  let scheme = call_598442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598442.url(scheme.get, call_598442.host, call_598442.base,
                         call_598442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598442, url, valid)

proc call*(call_598443: Call_AdsenseMetadataDimensionsList_598432;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598444 = newJObject()
  add(query_598444, "fields", newJString(fields))
  add(query_598444, "quotaUser", newJString(quotaUser))
  add(query_598444, "alt", newJString(alt))
  add(query_598444, "oauth_token", newJString(oauthToken))
  add(query_598444, "userIp", newJString(userIp))
  add(query_598444, "key", newJString(key))
  add(query_598444, "prettyPrint", newJBool(prettyPrint))
  result = call_598443.call(nil, query_598444, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_598432(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_598433,
    base: "/adsense/v1.3", url: url_AdsenseMetadataDimensionsList_598434,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_598445 = ref object of OpenApiRestCall_597424
proc url_AdsenseMetadataMetricsList_598447(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_598446(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598448 = query.getOrDefault("fields")
  valid_598448 = validateParameter(valid_598448, JString, required = false,
                                 default = nil)
  if valid_598448 != nil:
    section.add "fields", valid_598448
  var valid_598449 = query.getOrDefault("quotaUser")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "quotaUser", valid_598449
  var valid_598450 = query.getOrDefault("alt")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = newJString("json"))
  if valid_598450 != nil:
    section.add "alt", valid_598450
  var valid_598451 = query.getOrDefault("oauth_token")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "oauth_token", valid_598451
  var valid_598452 = query.getOrDefault("userIp")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "userIp", valid_598452
  var valid_598453 = query.getOrDefault("key")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "key", valid_598453
  var valid_598454 = query.getOrDefault("prettyPrint")
  valid_598454 = validateParameter(valid_598454, JBool, required = false,
                                 default = newJBool(true))
  if valid_598454 != nil:
    section.add "prettyPrint", valid_598454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598455: Call_AdsenseMetadataMetricsList_598445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_598455.validator(path, query, header, formData, body)
  let scheme = call_598455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598455.url(scheme.get, call_598455.host, call_598455.base,
                         call_598455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598455, url, valid)

proc call*(call_598456: Call_AdsenseMetadataMetricsList_598445;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## adsenseMetadataMetricsList
  ## List the metadata for the metrics available to this AdSense account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598457 = newJObject()
  add(query_598457, "fields", newJString(fields))
  add(query_598457, "quotaUser", newJString(quotaUser))
  add(query_598457, "alt", newJString(alt))
  add(query_598457, "oauth_token", newJString(oauthToken))
  add(query_598457, "userIp", newJString(userIp))
  add(query_598457, "key", newJString(key))
  add(query_598457, "prettyPrint", newJBool(prettyPrint))
  result = call_598456.call(nil, query_598457, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_598445(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_598446, base: "/adsense/v1.3",
    url: url_AdsenseMetadataMetricsList_598447, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_598458 = ref object of OpenApiRestCall_597424
proc url_AdsenseReportsGenerate_598460(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_598459(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  var valid_598461 = query.getOrDefault("useTimezoneReporting")
  valid_598461 = validateParameter(valid_598461, JBool, required = false, default = nil)
  if valid_598461 != nil:
    section.add "useTimezoneReporting", valid_598461
  var valid_598462 = query.getOrDefault("locale")
  valid_598462 = validateParameter(valid_598462, JString, required = false,
                                 default = nil)
  if valid_598462 != nil:
    section.add "locale", valid_598462
  var valid_598463 = query.getOrDefault("fields")
  valid_598463 = validateParameter(valid_598463, JString, required = false,
                                 default = nil)
  if valid_598463 != nil:
    section.add "fields", valid_598463
  var valid_598464 = query.getOrDefault("quotaUser")
  valid_598464 = validateParameter(valid_598464, JString, required = false,
                                 default = nil)
  if valid_598464 != nil:
    section.add "quotaUser", valid_598464
  var valid_598465 = query.getOrDefault("alt")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = newJString("json"))
  if valid_598465 != nil:
    section.add "alt", valid_598465
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_598466 = query.getOrDefault("endDate")
  valid_598466 = validateParameter(valid_598466, JString, required = true,
                                 default = nil)
  if valid_598466 != nil:
    section.add "endDate", valid_598466
  var valid_598467 = query.getOrDefault("currency")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "currency", valid_598467
  var valid_598468 = query.getOrDefault("startDate")
  valid_598468 = validateParameter(valid_598468, JString, required = true,
                                 default = nil)
  if valid_598468 != nil:
    section.add "startDate", valid_598468
  var valid_598469 = query.getOrDefault("sort")
  valid_598469 = validateParameter(valid_598469, JArray, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "sort", valid_598469
  var valid_598470 = query.getOrDefault("oauth_token")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "oauth_token", valid_598470
  var valid_598471 = query.getOrDefault("accountId")
  valid_598471 = validateParameter(valid_598471, JArray, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "accountId", valid_598471
  var valid_598472 = query.getOrDefault("userIp")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "userIp", valid_598472
  var valid_598473 = query.getOrDefault("maxResults")
  valid_598473 = validateParameter(valid_598473, JInt, required = false, default = nil)
  if valid_598473 != nil:
    section.add "maxResults", valid_598473
  var valid_598474 = query.getOrDefault("key")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = nil)
  if valid_598474 != nil:
    section.add "key", valid_598474
  var valid_598475 = query.getOrDefault("metric")
  valid_598475 = validateParameter(valid_598475, JArray, required = false,
                                 default = nil)
  if valid_598475 != nil:
    section.add "metric", valid_598475
  var valid_598476 = query.getOrDefault("prettyPrint")
  valid_598476 = validateParameter(valid_598476, JBool, required = false,
                                 default = newJBool(true))
  if valid_598476 != nil:
    section.add "prettyPrint", valid_598476
  var valid_598477 = query.getOrDefault("dimension")
  valid_598477 = validateParameter(valid_598477, JArray, required = false,
                                 default = nil)
  if valid_598477 != nil:
    section.add "dimension", valid_598477
  var valid_598478 = query.getOrDefault("filter")
  valid_598478 = validateParameter(valid_598478, JArray, required = false,
                                 default = nil)
  if valid_598478 != nil:
    section.add "filter", valid_598478
  var valid_598479 = query.getOrDefault("startIndex")
  valid_598479 = validateParameter(valid_598479, JInt, required = false, default = nil)
  if valid_598479 != nil:
    section.add "startIndex", valid_598479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598480: Call_AdsenseReportsGenerate_598458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_598480.validator(path, query, header, formData, body)
  let scheme = call_598480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598480.url(scheme.get, call_598480.host, call_598480.base,
                         call_598480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598480, url, valid)

proc call*(call_598481: Call_AdsenseReportsGenerate_598458; endDate: string;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
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
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
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
  var query_598482 = newJObject()
  add(query_598482, "useTimezoneReporting", newJBool(useTimezoneReporting))
  add(query_598482, "locale", newJString(locale))
  add(query_598482, "fields", newJString(fields))
  add(query_598482, "quotaUser", newJString(quotaUser))
  add(query_598482, "alt", newJString(alt))
  add(query_598482, "endDate", newJString(endDate))
  add(query_598482, "currency", newJString(currency))
  add(query_598482, "startDate", newJString(startDate))
  if sort != nil:
    query_598482.add "sort", sort
  add(query_598482, "oauth_token", newJString(oauthToken))
  if accountId != nil:
    query_598482.add "accountId", accountId
  add(query_598482, "userIp", newJString(userIp))
  add(query_598482, "maxResults", newJInt(maxResults))
  add(query_598482, "key", newJString(key))
  if metric != nil:
    query_598482.add "metric", metric
  add(query_598482, "prettyPrint", newJBool(prettyPrint))
  if dimension != nil:
    query_598482.add "dimension", dimension
  if filter != nil:
    query_598482.add "filter", filter
  add(query_598482, "startIndex", newJInt(startIndex))
  result = call_598481.call(nil, query_598482, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_598458(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_598459, base: "/adsense/v1.3",
    url: url_AdsenseReportsGenerate_598460, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_598483 = ref object of OpenApiRestCall_597424
proc url_AdsenseReportsSavedList_598485(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_598484(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598486 = query.getOrDefault("fields")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "fields", valid_598486
  var valid_598487 = query.getOrDefault("pageToken")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "pageToken", valid_598487
  var valid_598488 = query.getOrDefault("quotaUser")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "quotaUser", valid_598488
  var valid_598489 = query.getOrDefault("alt")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = newJString("json"))
  if valid_598489 != nil:
    section.add "alt", valid_598489
  var valid_598490 = query.getOrDefault("oauth_token")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = nil)
  if valid_598490 != nil:
    section.add "oauth_token", valid_598490
  var valid_598491 = query.getOrDefault("userIp")
  valid_598491 = validateParameter(valid_598491, JString, required = false,
                                 default = nil)
  if valid_598491 != nil:
    section.add "userIp", valid_598491
  var valid_598492 = query.getOrDefault("maxResults")
  valid_598492 = validateParameter(valid_598492, JInt, required = false, default = nil)
  if valid_598492 != nil:
    section.add "maxResults", valid_598492
  var valid_598493 = query.getOrDefault("key")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = nil)
  if valid_598493 != nil:
    section.add "key", valid_598493
  var valid_598494 = query.getOrDefault("prettyPrint")
  valid_598494 = validateParameter(valid_598494, JBool, required = false,
                                 default = newJBool(true))
  if valid_598494 != nil:
    section.add "prettyPrint", valid_598494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598495: Call_AdsenseReportsSavedList_598483; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_598495.validator(path, query, header, formData, body)
  let scheme = call_598495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598495.url(scheme.get, call_598495.host, call_598495.base,
                         call_598495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598495, url, valid)

proc call*(call_598496: Call_AdsenseReportsSavedList_598483; fields: string = "";
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598497 = newJObject()
  add(query_598497, "fields", newJString(fields))
  add(query_598497, "pageToken", newJString(pageToken))
  add(query_598497, "quotaUser", newJString(quotaUser))
  add(query_598497, "alt", newJString(alt))
  add(query_598497, "oauth_token", newJString(oauthToken))
  add(query_598497, "userIp", newJString(userIp))
  add(query_598497, "maxResults", newJInt(maxResults))
  add(query_598497, "key", newJString(key))
  add(query_598497, "prettyPrint", newJBool(prettyPrint))
  result = call_598496.call(nil, query_598497, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_598483(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_598484, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedList_598485, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_598498 = ref object of OpenApiRestCall_597424
proc url_AdsenseReportsSavedGenerate_598500(protocol: Scheme; host: string;
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

proc validate_AdsenseReportsSavedGenerate_598499(path: JsonNode; query: JsonNode;
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
  var valid_598501 = path.getOrDefault("savedReportId")
  valid_598501 = validateParameter(valid_598501, JString, required = true,
                                 default = nil)
  if valid_598501 != nil:
    section.add "savedReportId", valid_598501
  result.add "path", section
  ## parameters in `query` object:
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  section = newJObject()
  var valid_598502 = query.getOrDefault("locale")
  valid_598502 = validateParameter(valid_598502, JString, required = false,
                                 default = nil)
  if valid_598502 != nil:
    section.add "locale", valid_598502
  var valid_598503 = query.getOrDefault("fields")
  valid_598503 = validateParameter(valid_598503, JString, required = false,
                                 default = nil)
  if valid_598503 != nil:
    section.add "fields", valid_598503
  var valid_598504 = query.getOrDefault("quotaUser")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "quotaUser", valid_598504
  var valid_598505 = query.getOrDefault("alt")
  valid_598505 = validateParameter(valid_598505, JString, required = false,
                                 default = newJString("json"))
  if valid_598505 != nil:
    section.add "alt", valid_598505
  var valid_598506 = query.getOrDefault("oauth_token")
  valid_598506 = validateParameter(valid_598506, JString, required = false,
                                 default = nil)
  if valid_598506 != nil:
    section.add "oauth_token", valid_598506
  var valid_598507 = query.getOrDefault("userIp")
  valid_598507 = validateParameter(valid_598507, JString, required = false,
                                 default = nil)
  if valid_598507 != nil:
    section.add "userIp", valid_598507
  var valid_598508 = query.getOrDefault("maxResults")
  valid_598508 = validateParameter(valid_598508, JInt, required = false, default = nil)
  if valid_598508 != nil:
    section.add "maxResults", valid_598508
  var valid_598509 = query.getOrDefault("key")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "key", valid_598509
  var valid_598510 = query.getOrDefault("prettyPrint")
  valid_598510 = validateParameter(valid_598510, JBool, required = false,
                                 default = newJBool(true))
  if valid_598510 != nil:
    section.add "prettyPrint", valid_598510
  var valid_598511 = query.getOrDefault("startIndex")
  valid_598511 = validateParameter(valid_598511, JInt, required = false, default = nil)
  if valid_598511 != nil:
    section.add "startIndex", valid_598511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598512: Call_AdsenseReportsSavedGenerate_598498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_598512.validator(path, query, header, formData, body)
  let scheme = call_598512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598512.url(scheme.get, call_598512.host, call_598512.base,
                         call_598512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598512, url, valid)

proc call*(call_598513: Call_AdsenseReportsSavedGenerate_598498;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  var path_598514 = newJObject()
  var query_598515 = newJObject()
  add(query_598515, "locale", newJString(locale))
  add(query_598515, "fields", newJString(fields))
  add(query_598515, "quotaUser", newJString(quotaUser))
  add(query_598515, "alt", newJString(alt))
  add(query_598515, "oauth_token", newJString(oauthToken))
  add(query_598515, "userIp", newJString(userIp))
  add(path_598514, "savedReportId", newJString(savedReportId))
  add(query_598515, "maxResults", newJInt(maxResults))
  add(query_598515, "key", newJString(key))
  add(query_598515, "prettyPrint", newJBool(prettyPrint))
  add(query_598515, "startIndex", newJInt(startIndex))
  result = call_598513.call(path_598514, query_598515, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_598498(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_598499, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedGenerate_598500, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_598516 = ref object of OpenApiRestCall_597424
proc url_AdsenseSavedadstylesList_598518(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_598517(path: JsonNode; query: JsonNode;
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598519 = query.getOrDefault("fields")
  valid_598519 = validateParameter(valid_598519, JString, required = false,
                                 default = nil)
  if valid_598519 != nil:
    section.add "fields", valid_598519
  var valid_598520 = query.getOrDefault("pageToken")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "pageToken", valid_598520
  var valid_598521 = query.getOrDefault("quotaUser")
  valid_598521 = validateParameter(valid_598521, JString, required = false,
                                 default = nil)
  if valid_598521 != nil:
    section.add "quotaUser", valid_598521
  var valid_598522 = query.getOrDefault("alt")
  valid_598522 = validateParameter(valid_598522, JString, required = false,
                                 default = newJString("json"))
  if valid_598522 != nil:
    section.add "alt", valid_598522
  var valid_598523 = query.getOrDefault("oauth_token")
  valid_598523 = validateParameter(valid_598523, JString, required = false,
                                 default = nil)
  if valid_598523 != nil:
    section.add "oauth_token", valid_598523
  var valid_598524 = query.getOrDefault("userIp")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "userIp", valid_598524
  var valid_598525 = query.getOrDefault("maxResults")
  valid_598525 = validateParameter(valid_598525, JInt, required = false, default = nil)
  if valid_598525 != nil:
    section.add "maxResults", valid_598525
  var valid_598526 = query.getOrDefault("key")
  valid_598526 = validateParameter(valid_598526, JString, required = false,
                                 default = nil)
  if valid_598526 != nil:
    section.add "key", valid_598526
  var valid_598527 = query.getOrDefault("prettyPrint")
  valid_598527 = validateParameter(valid_598527, JBool, required = false,
                                 default = newJBool(true))
  if valid_598527 != nil:
    section.add "prettyPrint", valid_598527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598528: Call_AdsenseSavedadstylesList_598516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_598528.validator(path, query, header, formData, body)
  let scheme = call_598528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598528.url(scheme.get, call_598528.host, call_598528.base,
                         call_598528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598528, url, valid)

proc call*(call_598529: Call_AdsenseSavedadstylesList_598516; fields: string = "";
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
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598530 = newJObject()
  add(query_598530, "fields", newJString(fields))
  add(query_598530, "pageToken", newJString(pageToken))
  add(query_598530, "quotaUser", newJString(quotaUser))
  add(query_598530, "alt", newJString(alt))
  add(query_598530, "oauth_token", newJString(oauthToken))
  add(query_598530, "userIp", newJString(userIp))
  add(query_598530, "maxResults", newJInt(maxResults))
  add(query_598530, "key", newJString(key))
  add(query_598530, "prettyPrint", newJBool(prettyPrint))
  result = call_598529.call(nil, query_598530, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_598516(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_598517, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesList_598518, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_598531 = ref object of OpenApiRestCall_597424
proc url_AdsenseSavedadstylesGet_598533(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseSavedadstylesGet_598532(path: JsonNode; query: JsonNode;
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
  var valid_598534 = path.getOrDefault("savedAdStyleId")
  valid_598534 = validateParameter(valid_598534, JString, required = true,
                                 default = nil)
  if valid_598534 != nil:
    section.add "savedAdStyleId", valid_598534
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598535 = query.getOrDefault("fields")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "fields", valid_598535
  var valid_598536 = query.getOrDefault("quotaUser")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "quotaUser", valid_598536
  var valid_598537 = query.getOrDefault("alt")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = newJString("json"))
  if valid_598537 != nil:
    section.add "alt", valid_598537
  var valid_598538 = query.getOrDefault("oauth_token")
  valid_598538 = validateParameter(valid_598538, JString, required = false,
                                 default = nil)
  if valid_598538 != nil:
    section.add "oauth_token", valid_598538
  var valid_598539 = query.getOrDefault("userIp")
  valid_598539 = validateParameter(valid_598539, JString, required = false,
                                 default = nil)
  if valid_598539 != nil:
    section.add "userIp", valid_598539
  var valid_598540 = query.getOrDefault("key")
  valid_598540 = validateParameter(valid_598540, JString, required = false,
                                 default = nil)
  if valid_598540 != nil:
    section.add "key", valid_598540
  var valid_598541 = query.getOrDefault("prettyPrint")
  valid_598541 = validateParameter(valid_598541, JBool, required = false,
                                 default = newJBool(true))
  if valid_598541 != nil:
    section.add "prettyPrint", valid_598541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598542: Call_AdsenseSavedadstylesGet_598531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_598542.validator(path, query, header, formData, body)
  let scheme = call_598542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598542.url(scheme.get, call_598542.host, call_598542.base,
                         call_598542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598542, url, valid)

proc call*(call_598543: Call_AdsenseSavedadstylesGet_598531;
          savedAdStyleId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## adsenseSavedadstylesGet
  ## Get a specific saved ad style from the user's account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598544 = newJObject()
  var query_598545 = newJObject()
  add(query_598545, "fields", newJString(fields))
  add(query_598545, "quotaUser", newJString(quotaUser))
  add(query_598545, "alt", newJString(alt))
  add(query_598545, "oauth_token", newJString(oauthToken))
  add(path_598544, "savedAdStyleId", newJString(savedAdStyleId))
  add(query_598545, "userIp", newJString(userIp))
  add(query_598545, "key", newJString(key))
  add(query_598545, "prettyPrint", newJBool(prettyPrint))
  result = call_598543.call(path_598544, query_598545, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_598531(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_598532, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesGet_598533, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
