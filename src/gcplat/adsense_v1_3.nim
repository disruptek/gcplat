
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "adsense"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsenseAccountsList_578626 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsList_578628(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAccountsList_578627(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List all accounts available to this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of accounts to include in the response, used for paging.
  section = newJObject()
  var valid_578740 = query.getOrDefault("key")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "key", valid_578740
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("userIp")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "userIp", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("pageToken")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "pageToken", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("maxResults")
  valid_578761 = validateParameter(valid_578761, JInt, required = false, default = nil)
  if valid_578761 != nil:
    section.add "maxResults", valid_578761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578784: Call_AdsenseAccountsList_578626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all accounts available to this AdSense account.
  ## 
  let valid = call_578784.validator(path, query, header, formData, body)
  let scheme = call_578784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578784.url(scheme.get, call_578784.host, call_578784.base,
                         call_578784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578784, url, valid)

proc call*(call_578855: Call_AdsenseAccountsList_578626; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAccountsList
  ## List all accounts available to this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through accounts. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in the response, used for paging.
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "userIp", newJString(userIp))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(query_578856, "pageToken", newJString(pageToken))
  add(query_578856, "fields", newJString(fields))
  add(query_578856, "maxResults", newJInt(maxResults))
  result = call_578855.call(nil, query_578856, nil, nil, nil)

var adsenseAccountsList* = Call_AdsenseAccountsList_578626(
    name: "adsenseAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsenseAccountsList_578627, base: "/adsense/v1.3",
    url: url_AdsenseAccountsList_578628, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsGet_578896 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsGet_578898(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAccountsGet_578897(path: JsonNode; query: JsonNode;
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
  var valid_578913 = path.getOrDefault("accountId")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "accountId", valid_578913
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   tree: JBool
  ##       : Whether the tree of sub accounts should be returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("userIp")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "userIp", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("tree")
  valid_578920 = validateParameter(valid_578920, JBool, required = false, default = nil)
  if valid_578920 != nil:
    section.add "tree", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_AdsenseAccountsGet_578896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected AdSense account.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_AdsenseAccountsGet_578896; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          tree: bool = false; fields: string = ""): Recallable =
  ## adsenseAccountsGet
  ## Get information about the selected AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   tree: bool
  ##       : Whether the tree of sub accounts should be returned.
  ##   accountId: string (required)
  ##            : Account to get information about.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "userIp", newJString(userIp))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(query_578925, "tree", newJBool(tree))
  add(path_578924, "accountId", newJString(accountId))
  add(query_578925, "fields", newJString(fields))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var adsenseAccountsGet* = Call_AdsenseAccountsGet_578896(
    name: "adsenseAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsenseAccountsGet_578897, base: "/adsense/v1.3",
    url: url_AdsenseAccountsGet_578898, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsList_578926 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdclientsList_578928(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdclientsList_578927(path: JsonNode; query: JsonNode;
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
  var valid_578929 = path.getOrDefault("accountId")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "accountId", valid_578929
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("alt")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("json"))
  if valid_578933 != nil:
    section.add "alt", valid_578933
  var valid_578934 = query.getOrDefault("userIp")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "userIp", valid_578934
  var valid_578935 = query.getOrDefault("quotaUser")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "quotaUser", valid_578935
  var valid_578936 = query.getOrDefault("pageToken")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "pageToken", valid_578936
  var valid_578937 = query.getOrDefault("fields")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "fields", valid_578937
  var valid_578938 = query.getOrDefault("maxResults")
  valid_578938 = validateParameter(valid_578938, JInt, required = false, default = nil)
  if valid_578938 != nil:
    section.add "maxResults", valid_578938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578939: Call_AdsenseAccountsAdclientsList_578926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in the specified account.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_AdsenseAccountsAdclientsList_578926;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsenseAccountsAdclientsList
  ## List all ad clients in the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account for which to list ad clients.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "userIp", newJString(userIp))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(query_578942, "pageToken", newJString(pageToken))
  add(path_578941, "accountId", newJString(accountId))
  add(query_578942, "fields", newJString(fields))
  add(query_578942, "maxResults", newJInt(maxResults))
  result = call_578940.call(path_578941, query_578942, nil, nil, nil)

var adsenseAccountsAdclientsList* = Call_AdsenseAccountsAdclientsList_578926(
    name: "adsenseAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsenseAccountsAdclientsList_578927,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdclientsList_578928,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_578943 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsList_578945(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsList_578944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578946 = path.getOrDefault("adClientId")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "adClientId", valid_578946
  var valid_578947 = path.getOrDefault("accountId")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "accountId", valid_578947
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_578948 = query.getOrDefault("key")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "key", valid_578948
  var valid_578949 = query.getOrDefault("prettyPrint")
  valid_578949 = validateParameter(valid_578949, JBool, required = false,
                                 default = newJBool(true))
  if valid_578949 != nil:
    section.add "prettyPrint", valid_578949
  var valid_578950 = query.getOrDefault("oauth_token")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "oauth_token", valid_578950
  var valid_578951 = query.getOrDefault("alt")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("json"))
  if valid_578951 != nil:
    section.add "alt", valid_578951
  var valid_578952 = query.getOrDefault("userIp")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "userIp", valid_578952
  var valid_578953 = query.getOrDefault("quotaUser")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "quotaUser", valid_578953
  var valid_578954 = query.getOrDefault("pageToken")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "pageToken", valid_578954
  var valid_578955 = query.getOrDefault("includeInactive")
  valid_578955 = validateParameter(valid_578955, JBool, required = false, default = nil)
  if valid_578955 != nil:
    section.add "includeInactive", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("maxResults")
  valid_578957 = validateParameter(valid_578957, JInt, required = false, default = nil)
  if valid_578957 != nil:
    section.add "maxResults", valid_578957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578958: Call_AdsenseAccountsAdunitsList_578943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_578958.validator(path, query, header, formData, body)
  let scheme = call_578958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578958.url(scheme.get, call_578958.host, call_578958.base,
                         call_578958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578958, url, valid)

proc call*(call_578959: Call_AdsenseAccountsAdunitsList_578943; adClientId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; includeInactive: bool = false;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAccountsAdunitsList
  ## List all ad units in the specified ad client for the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_578960 = newJObject()
  var query_578961 = newJObject()
  add(query_578961, "key", newJString(key))
  add(query_578961, "prettyPrint", newJBool(prettyPrint))
  add(query_578961, "oauth_token", newJString(oauthToken))
  add(query_578961, "alt", newJString(alt))
  add(query_578961, "userIp", newJString(userIp))
  add(query_578961, "quotaUser", newJString(quotaUser))
  add(query_578961, "pageToken", newJString(pageToken))
  add(path_578960, "adClientId", newJString(adClientId))
  add(path_578960, "accountId", newJString(accountId))
  add(query_578961, "includeInactive", newJBool(includeInactive))
  add(query_578961, "fields", newJString(fields))
  add(query_578961, "maxResults", newJInt(maxResults))
  result = call_578959.call(path_578960, query_578961, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_578943(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_578944, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsList_578945, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_578962 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsGet_578964(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGet_578963(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to retrieve.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578965 = path.getOrDefault("adClientId")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "adClientId", valid_578965
  var valid_578966 = path.getOrDefault("adUnitId")
  valid_578966 = validateParameter(valid_578966, JString, required = true,
                                 default = nil)
  if valid_578966 != nil:
    section.add "adUnitId", valid_578966
  var valid_578967 = path.getOrDefault("accountId")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "accountId", valid_578967
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578968 = query.getOrDefault("key")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "key", valid_578968
  var valid_578969 = query.getOrDefault("prettyPrint")
  valid_578969 = validateParameter(valid_578969, JBool, required = false,
                                 default = newJBool(true))
  if valid_578969 != nil:
    section.add "prettyPrint", valid_578969
  var valid_578970 = query.getOrDefault("oauth_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "oauth_token", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("userIp")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "userIp", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578975: Call_AdsenseAccountsAdunitsGet_578962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_AdsenseAccountsAdunitsGet_578962; adClientId: string;
          adUnitId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAccountsAdunitsGet
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578977 = newJObject()
  var query_578978 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "userIp", newJString(userIp))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(path_578977, "adClientId", newJString(adClientId))
  add(path_578977, "adUnitId", newJString(adUnitId))
  add(path_578977, "accountId", newJString(accountId))
  add(query_578978, "fields", newJString(fields))
  result = call_578976.call(path_578977, query_578978, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_578962(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_578963, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAdunitsGet_578964, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_578979 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsGetAdCode_578981(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGetAdCode_578980(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get the code for.
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578982 = path.getOrDefault("adClientId")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "adClientId", valid_578982
  var valid_578983 = path.getOrDefault("adUnitId")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "adUnitId", valid_578983
  var valid_578984 = path.getOrDefault("accountId")
  valid_578984 = validateParameter(valid_578984, JString, required = true,
                                 default = nil)
  if valid_578984 != nil:
    section.add "accountId", valid_578984
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578985 = query.getOrDefault("key")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "key", valid_578985
  var valid_578986 = query.getOrDefault("prettyPrint")
  valid_578986 = validateParameter(valid_578986, JBool, required = false,
                                 default = newJBool(true))
  if valid_578986 != nil:
    section.add "prettyPrint", valid_578986
  var valid_578987 = query.getOrDefault("oauth_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "oauth_token", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("userIp")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "userIp", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578992: Call_AdsenseAccountsAdunitsGetAdCode_578979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_578992.validator(path, query, header, formData, body)
  let scheme = call_578992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578992.url(scheme.get, call_578992.host, call_578992.base,
                         call_578992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578992, url, valid)

proc call*(call_578993: Call_AdsenseAccountsAdunitsGetAdCode_578979;
          adClientId: string; adUnitId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578994 = newJObject()
  var query_578995 = newJObject()
  add(query_578995, "key", newJString(key))
  add(query_578995, "prettyPrint", newJBool(prettyPrint))
  add(query_578995, "oauth_token", newJString(oauthToken))
  add(query_578995, "alt", newJString(alt))
  add(query_578995, "userIp", newJString(userIp))
  add(query_578995, "quotaUser", newJString(quotaUser))
  add(path_578994, "adClientId", newJString(adClientId))
  add(path_578994, "adUnitId", newJString(adUnitId))
  add(path_578994, "accountId", newJString(accountId))
  add(query_578995, "fields", newJString(fields))
  result = call_578993.call(path_578994, query_578995, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_578979(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_578980,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsGetAdCode_578981,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_578996 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsCustomchannelsList_578998(protocol: Scheme;
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

proc validate_AdsenseAccountsAdunitsCustomchannelsList_578997(path: JsonNode;
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
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578999 = path.getOrDefault("adClientId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "adClientId", valid_578999
  var valid_579000 = path.getOrDefault("adUnitId")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "adUnitId", valid_579000
  var valid_579001 = path.getOrDefault("accountId")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "accountId", valid_579001
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579002 = query.getOrDefault("key")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "key", valid_579002
  var valid_579003 = query.getOrDefault("prettyPrint")
  valid_579003 = validateParameter(valid_579003, JBool, required = false,
                                 default = newJBool(true))
  if valid_579003 != nil:
    section.add "prettyPrint", valid_579003
  var valid_579004 = query.getOrDefault("oauth_token")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "oauth_token", valid_579004
  var valid_579005 = query.getOrDefault("alt")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("json"))
  if valid_579005 != nil:
    section.add "alt", valid_579005
  var valid_579006 = query.getOrDefault("userIp")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "userIp", valid_579006
  var valid_579007 = query.getOrDefault("quotaUser")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "quotaUser", valid_579007
  var valid_579008 = query.getOrDefault("pageToken")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "pageToken", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("maxResults")
  valid_579010 = validateParameter(valid_579010, JInt, required = false, default = nil)
  if valid_579010 != nil:
    section.add "maxResults", valid_579010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579011: Call_AdsenseAccountsAdunitsCustomchannelsList_578996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_579011.validator(path, query, header, formData, body)
  let scheme = call_579011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579011.url(scheme.get, call_579011.host, call_579011.base,
                         call_579011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579011, url, valid)

proc call*(call_579012: Call_AdsenseAccountsAdunitsCustomchannelsList_578996;
          adClientId: string; adUnitId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAccountsAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_579013 = newJObject()
  var query_579014 = newJObject()
  add(query_579014, "key", newJString(key))
  add(query_579014, "prettyPrint", newJBool(prettyPrint))
  add(query_579014, "oauth_token", newJString(oauthToken))
  add(query_579014, "alt", newJString(alt))
  add(query_579014, "userIp", newJString(userIp))
  add(query_579014, "quotaUser", newJString(quotaUser))
  add(query_579014, "pageToken", newJString(pageToken))
  add(path_579013, "adClientId", newJString(adClientId))
  add(path_579013, "adUnitId", newJString(adUnitId))
  add(path_579013, "accountId", newJString(accountId))
  add(query_579014, "fields", newJString(fields))
  add(query_579014, "maxResults", newJInt(maxResults))
  result = call_579012.call(path_579013, query_579014, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_578996(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_578997,
    base: "/adsense/v1.3", url: url_AdsenseAccountsAdunitsCustomchannelsList_578998,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_579015 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsCustomchannelsList_579017(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsList_579016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579018 = path.getOrDefault("adClientId")
  valid_579018 = validateParameter(valid_579018, JString, required = true,
                                 default = nil)
  if valid_579018 != nil:
    section.add "adClientId", valid_579018
  var valid_579019 = path.getOrDefault("accountId")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "accountId", valid_579019
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579020 = query.getOrDefault("key")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "key", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("alt")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("json"))
  if valid_579023 != nil:
    section.add "alt", valid_579023
  var valid_579024 = query.getOrDefault("userIp")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "userIp", valid_579024
  var valid_579025 = query.getOrDefault("quotaUser")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "quotaUser", valid_579025
  var valid_579026 = query.getOrDefault("pageToken")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "pageToken", valid_579026
  var valid_579027 = query.getOrDefault("fields")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "fields", valid_579027
  var valid_579028 = query.getOrDefault("maxResults")
  valid_579028 = validateParameter(valid_579028, JInt, required = false, default = nil)
  if valid_579028 != nil:
    section.add "maxResults", valid_579028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579029: Call_AdsenseAccountsCustomchannelsList_579015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_AdsenseAccountsCustomchannelsList_579015;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAccountsCustomchannelsList
  ## List all custom channels in the specified ad client for the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "userIp", newJString(userIp))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(query_579032, "pageToken", newJString(pageToken))
  add(path_579031, "adClientId", newJString(adClientId))
  add(path_579031, "accountId", newJString(accountId))
  add(query_579032, "fields", newJString(fields))
  add(query_579032, "maxResults", newJInt(maxResults))
  result = call_579030.call(path_579031, query_579032, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_579015(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_579016,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsList_579017,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_579033 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsCustomchannelsGet_579035(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsGet_579034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579036 = path.getOrDefault("adClientId")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "adClientId", valid_579036
  var valid_579037 = path.getOrDefault("accountId")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "accountId", valid_579037
  var valid_579038 = path.getOrDefault("customChannelId")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "customChannelId", valid_579038
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("prettyPrint")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "prettyPrint", valid_579040
  var valid_579041 = query.getOrDefault("oauth_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "oauth_token", valid_579041
  var valid_579042 = query.getOrDefault("alt")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("json"))
  if valid_579042 != nil:
    section.add "alt", valid_579042
  var valid_579043 = query.getOrDefault("userIp")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "userIp", valid_579043
  var valid_579044 = query.getOrDefault("quotaUser")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "quotaUser", valid_579044
  var valid_579045 = query.getOrDefault("fields")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "fields", valid_579045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_AdsenseAccountsCustomchannelsGet_579033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_AdsenseAccountsCustomchannelsGet_579033;
          adClientId: string; accountId: string; customChannelId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsenseAccountsCustomchannelsGet
  ## Get the specified custom channel from the specified ad client for the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "userIp", newJString(userIp))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(path_579048, "adClientId", newJString(adClientId))
  add(path_579048, "accountId", newJString(accountId))
  add(path_579048, "customChannelId", newJString(customChannelId))
  add(query_579049, "fields", newJString(fields))
  result = call_579047.call(path_579048, query_579049, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_579033(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_579034,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsGet_579035,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_579050 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsCustomchannelsAdunitsList_579052(protocol: Scheme;
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

proc validate_AdsenseAccountsCustomchannelsAdunitsList_579051(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579053 = path.getOrDefault("adClientId")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "adClientId", valid_579053
  var valid_579054 = path.getOrDefault("accountId")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "accountId", valid_579054
  var valid_579055 = path.getOrDefault("customChannelId")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "customChannelId", valid_579055
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("userIp")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "userIp", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("pageToken")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "pageToken", valid_579062
  var valid_579063 = query.getOrDefault("includeInactive")
  valid_579063 = validateParameter(valid_579063, JBool, required = false, default = nil)
  if valid_579063 != nil:
    section.add "includeInactive", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("maxResults")
  valid_579065 = validateParameter(valid_579065, JInt, required = false, default = nil)
  if valid_579065 != nil:
    section.add "maxResults", valid_579065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579066: Call_AdsenseAccountsCustomchannelsAdunitsList_579050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_AdsenseAccountsCustomchannelsAdunitsList_579050;
          adClientId: string; accountId: string; customChannelId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; includeInactive: bool = false; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsenseAccountsCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_579068 = newJObject()
  var query_579069 = newJObject()
  add(query_579069, "key", newJString(key))
  add(query_579069, "prettyPrint", newJBool(prettyPrint))
  add(query_579069, "oauth_token", newJString(oauthToken))
  add(query_579069, "alt", newJString(alt))
  add(query_579069, "userIp", newJString(userIp))
  add(query_579069, "quotaUser", newJString(quotaUser))
  add(query_579069, "pageToken", newJString(pageToken))
  add(path_579068, "adClientId", newJString(adClientId))
  add(path_579068, "accountId", newJString(accountId))
  add(path_579068, "customChannelId", newJString(customChannelId))
  add(query_579069, "includeInactive", newJBool(includeInactive))
  add(query_579069, "fields", newJString(fields))
  add(query_579069, "maxResults", newJInt(maxResults))
  result = call_579067.call(path_579068, query_579069, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_579050(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_579051,
    base: "/adsense/v1.3", url: url_AdsenseAccountsCustomchannelsAdunitsList_579052,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_579070 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsUrlchannelsList_579072(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsUrlchannelsList_579071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  ##   accountId: JString (required)
  ##            : Account to which the ad client belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579073 = path.getOrDefault("adClientId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "adClientId", valid_579073
  var valid_579074 = path.getOrDefault("accountId")
  valid_579074 = validateParameter(valid_579074, JString, required = true,
                                 default = nil)
  if valid_579074 != nil:
    section.add "accountId", valid_579074
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  section = newJObject()
  var valid_579075 = query.getOrDefault("key")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "key", valid_579075
  var valid_579076 = query.getOrDefault("prettyPrint")
  valid_579076 = validateParameter(valid_579076, JBool, required = false,
                                 default = newJBool(true))
  if valid_579076 != nil:
    section.add "prettyPrint", valid_579076
  var valid_579077 = query.getOrDefault("oauth_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "oauth_token", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("userIp")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "userIp", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("pageToken")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "pageToken", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("maxResults")
  valid_579083 = validateParameter(valid_579083, JInt, required = false, default = nil)
  if valid_579083 != nil:
    section.add "maxResults", valid_579083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579084: Call_AdsenseAccountsUrlchannelsList_579070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_579084.validator(path, query, header, formData, body)
  let scheme = call_579084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579084.url(scheme.get, call_579084.host, call_579084.base,
                         call_579084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579084, url, valid)

proc call*(call_579085: Call_AdsenseAccountsUrlchannelsList_579070;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAccountsUrlchannelsList
  ## List all URL channels in the specified ad client for the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  var path_579086 = newJObject()
  var query_579087 = newJObject()
  add(query_579087, "key", newJString(key))
  add(query_579087, "prettyPrint", newJBool(prettyPrint))
  add(query_579087, "oauth_token", newJString(oauthToken))
  add(query_579087, "alt", newJString(alt))
  add(query_579087, "userIp", newJString(userIp))
  add(query_579087, "quotaUser", newJString(quotaUser))
  add(query_579087, "pageToken", newJString(pageToken))
  add(path_579086, "adClientId", newJString(adClientId))
  add(path_579086, "accountId", newJString(accountId))
  add(query_579087, "fields", newJString(fields))
  add(query_579087, "maxResults", newJInt(maxResults))
  result = call_579085.call(path_579086, query_579087, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_579070(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_579071,
    base: "/adsense/v1.3", url: url_AdsenseAccountsUrlchannelsList_579072,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_579088 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAlertsList_579090(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAlertsList_579089(path: JsonNode; query: JsonNode;
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
  var valid_579091 = path.getOrDefault("accountId")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "accountId", valid_579091
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579092 = query.getOrDefault("key")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "key", valid_579092
  var valid_579093 = query.getOrDefault("prettyPrint")
  valid_579093 = validateParameter(valid_579093, JBool, required = false,
                                 default = newJBool(true))
  if valid_579093 != nil:
    section.add "prettyPrint", valid_579093
  var valid_579094 = query.getOrDefault("oauth_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "oauth_token", valid_579094
  var valid_579095 = query.getOrDefault("locale")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "locale", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("userIp")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "userIp", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579100: Call_AdsenseAccountsAlertsList_579088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_AdsenseAccountsAlertsList_579088; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          locale: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAccountsAlertsList
  ## List the alerts for the specified AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   accountId: string (required)
  ##            : Account for which to retrieve the alerts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "locale", newJString(locale))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "userIp", newJString(userIp))
  add(query_579103, "quotaUser", newJString(quotaUser))
  add(path_579102, "accountId", newJString(accountId))
  add(query_579103, "fields", newJString(fields))
  result = call_579101.call(path_579102, query_579103, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_579088(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_579089, base: "/adsense/v1.3",
    url: url_AdsenseAccountsAlertsList_579090, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_579104 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsReportsGenerate_579106(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsGenerate_579105(path: JsonNode;
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
  var valid_579107 = path.getOrDefault("accountId")
  valid_579107 = validateParameter(valid_579107, JString, required = true,
                                 default = nil)
  if valid_579107 != nil:
    section.add "accountId", valid_579107
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   currency: JString
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  section = newJObject()
  var valid_579108 = query.getOrDefault("key")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "key", valid_579108
  var valid_579109 = query.getOrDefault("prettyPrint")
  valid_579109 = validateParameter(valid_579109, JBool, required = false,
                                 default = newJBool(true))
  if valid_579109 != nil:
    section.add "prettyPrint", valid_579109
  var valid_579110 = query.getOrDefault("oauth_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "oauth_token", valid_579110
  var valid_579111 = query.getOrDefault("locale")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "locale", valid_579111
  var valid_579112 = query.getOrDefault("currency")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "currency", valid_579112
  var valid_579113 = query.getOrDefault("alt")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = newJString("json"))
  if valid_579113 != nil:
    section.add "alt", valid_579113
  var valid_579114 = query.getOrDefault("userIp")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "userIp", valid_579114
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579115 = query.getOrDefault("endDate")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "endDate", valid_579115
  var valid_579116 = query.getOrDefault("quotaUser")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "quotaUser", valid_579116
  var valid_579117 = query.getOrDefault("startIndex")
  valid_579117 = validateParameter(valid_579117, JInt, required = false, default = nil)
  if valid_579117 != nil:
    section.add "startIndex", valid_579117
  var valid_579118 = query.getOrDefault("filter")
  valid_579118 = validateParameter(valid_579118, JArray, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "filter", valid_579118
  var valid_579119 = query.getOrDefault("useTimezoneReporting")
  valid_579119 = validateParameter(valid_579119, JBool, required = false, default = nil)
  if valid_579119 != nil:
    section.add "useTimezoneReporting", valid_579119
  var valid_579120 = query.getOrDefault("dimension")
  valid_579120 = validateParameter(valid_579120, JArray, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "dimension", valid_579120
  var valid_579121 = query.getOrDefault("metric")
  valid_579121 = validateParameter(valid_579121, JArray, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "metric", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("startDate")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "startDate", valid_579123
  var valid_579124 = query.getOrDefault("maxResults")
  valid_579124 = validateParameter(valid_579124, JInt, required = false, default = nil)
  if valid_579124 != nil:
    section.add "maxResults", valid_579124
  var valid_579125 = query.getOrDefault("sort")
  valid_579125 = validateParameter(valid_579125, JArray, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "sort", valid_579125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579126: Call_AdsenseAccountsReportsGenerate_579104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579126.validator(path, query, header, formData, body)
  let scheme = call_579126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579126.url(scheme.get, call_579126.host, call_579126.base,
                         call_579126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579126, url, valid)

proc call*(call_579127: Call_AdsenseAccountsReportsGenerate_579104;
          endDate: string; accountId: string; startDate: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          currency: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; startIndex: int = 0; filter: JsonNode = nil;
          useTimezoneReporting: bool = false; dimension: JsonNode = nil;
          metric: JsonNode = nil; fields: string = ""; maxResults: int = 0;
          sort: JsonNode = nil): Recallable =
  ## adsenseAccountsReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   currency: string
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   useTimezoneReporting: bool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   accountId: string (required)
  ##            : Account upon which to report.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  var path_579128 = newJObject()
  var query_579129 = newJObject()
  add(query_579129, "key", newJString(key))
  add(query_579129, "prettyPrint", newJBool(prettyPrint))
  add(query_579129, "oauth_token", newJString(oauthToken))
  add(query_579129, "locale", newJString(locale))
  add(query_579129, "currency", newJString(currency))
  add(query_579129, "alt", newJString(alt))
  add(query_579129, "userIp", newJString(userIp))
  add(query_579129, "endDate", newJString(endDate))
  add(query_579129, "quotaUser", newJString(quotaUser))
  add(query_579129, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579129.add "filter", filter
  add(query_579129, "useTimezoneReporting", newJBool(useTimezoneReporting))
  if dimension != nil:
    query_579129.add "dimension", dimension
  add(path_579128, "accountId", newJString(accountId))
  if metric != nil:
    query_579129.add "metric", metric
  add(query_579129, "fields", newJString(fields))
  add(query_579129, "startDate", newJString(startDate))
  add(query_579129, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579129.add "sort", sort
  result = call_579127.call(path_579128, query_579129, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_579104(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_579105,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsGenerate_579106,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_579130 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsReportsSavedList_579132(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedList_579131(path: JsonNode;
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
  var valid_579133 = path.getOrDefault("accountId")
  valid_579133 = validateParameter(valid_579133, JString, required = true,
                                 default = nil)
  if valid_579133 != nil:
    section.add "accountId", valid_579133
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  section = newJObject()
  var valid_579134 = query.getOrDefault("key")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "key", valid_579134
  var valid_579135 = query.getOrDefault("prettyPrint")
  valid_579135 = validateParameter(valid_579135, JBool, required = false,
                                 default = newJBool(true))
  if valid_579135 != nil:
    section.add "prettyPrint", valid_579135
  var valid_579136 = query.getOrDefault("oauth_token")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "oauth_token", valid_579136
  var valid_579137 = query.getOrDefault("alt")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = newJString("json"))
  if valid_579137 != nil:
    section.add "alt", valid_579137
  var valid_579138 = query.getOrDefault("userIp")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "userIp", valid_579138
  var valid_579139 = query.getOrDefault("quotaUser")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "quotaUser", valid_579139
  var valid_579140 = query.getOrDefault("pageToken")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "pageToken", valid_579140
  var valid_579141 = query.getOrDefault("fields")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "fields", valid_579141
  var valid_579142 = query.getOrDefault("maxResults")
  valid_579142 = validateParameter(valid_579142, JInt, required = false, default = nil)
  if valid_579142 != nil:
    section.add "maxResults", valid_579142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579143: Call_AdsenseAccountsReportsSavedList_579130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_579143.validator(path, query, header, formData, body)
  let scheme = call_579143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579143.url(scheme.get, call_579143.host, call_579143.base,
                         call_579143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579143, url, valid)

proc call*(call_579144: Call_AdsenseAccountsReportsSavedList_579130;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsenseAccountsReportsSavedList
  ## List all saved reports in the specified AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  var path_579145 = newJObject()
  var query_579146 = newJObject()
  add(query_579146, "key", newJString(key))
  add(query_579146, "prettyPrint", newJBool(prettyPrint))
  add(query_579146, "oauth_token", newJString(oauthToken))
  add(query_579146, "alt", newJString(alt))
  add(query_579146, "userIp", newJString(userIp))
  add(query_579146, "quotaUser", newJString(quotaUser))
  add(query_579146, "pageToken", newJString(pageToken))
  add(path_579145, "accountId", newJString(accountId))
  add(query_579146, "fields", newJString(fields))
  add(query_579146, "maxResults", newJInt(maxResults))
  result = call_579144.call(path_579145, query_579146, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_579130(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_579131,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedList_579132,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_579147 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsReportsSavedGenerate_579149(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedGenerate_579148(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   savedReportId: JString (required)
  ##                : The saved report to retrieve.
  ##   accountId: JString (required)
  ##            : Account to which the saved reports belong.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `savedReportId` field"
  var valid_579150 = path.getOrDefault("savedReportId")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "savedReportId", valid_579150
  var valid_579151 = path.getOrDefault("accountId")
  valid_579151 = validateParameter(valid_579151, JString, required = true,
                                 default = nil)
  if valid_579151 != nil:
    section.add "accountId", valid_579151
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  section = newJObject()
  var valid_579152 = query.getOrDefault("key")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "key", valid_579152
  var valid_579153 = query.getOrDefault("prettyPrint")
  valid_579153 = validateParameter(valid_579153, JBool, required = false,
                                 default = newJBool(true))
  if valid_579153 != nil:
    section.add "prettyPrint", valid_579153
  var valid_579154 = query.getOrDefault("oauth_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "oauth_token", valid_579154
  var valid_579155 = query.getOrDefault("locale")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "locale", valid_579155
  var valid_579156 = query.getOrDefault("alt")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = newJString("json"))
  if valid_579156 != nil:
    section.add "alt", valid_579156
  var valid_579157 = query.getOrDefault("userIp")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "userIp", valid_579157
  var valid_579158 = query.getOrDefault("quotaUser")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "quotaUser", valid_579158
  var valid_579159 = query.getOrDefault("startIndex")
  valid_579159 = validateParameter(valid_579159, JInt, required = false, default = nil)
  if valid_579159 != nil:
    section.add "startIndex", valid_579159
  var valid_579160 = query.getOrDefault("fields")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "fields", valid_579160
  var valid_579161 = query.getOrDefault("maxResults")
  valid_579161 = validateParameter(valid_579161, JInt, required = false, default = nil)
  if valid_579161 != nil:
    section.add "maxResults", valid_579161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579162: Call_AdsenseAccountsReportsSavedGenerate_579147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579162.validator(path, query, header, formData, body)
  let scheme = call_579162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579162.url(scheme.get, call_579162.host, call_579162.base,
                         call_579162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579162, url, valid)

proc call*(call_579163: Call_AdsenseAccountsReportsSavedGenerate_579147;
          savedReportId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAccountsReportsSavedGenerate
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  var path_579164 = newJObject()
  var query_579165 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(query_579165, "locale", newJString(locale))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "userIp", newJString(userIp))
  add(path_579164, "savedReportId", newJString(savedReportId))
  add(query_579165, "quotaUser", newJString(quotaUser))
  add(query_579165, "startIndex", newJInt(startIndex))
  add(path_579164, "accountId", newJString(accountId))
  add(query_579165, "fields", newJString(fields))
  add(query_579165, "maxResults", newJInt(maxResults))
  result = call_579163.call(path_579164, query_579165, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_579147(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_579148,
    base: "/adsense/v1.3", url: url_AdsenseAccountsReportsSavedGenerate_579149,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_579166 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsSavedadstylesList_579168(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesList_579167(path: JsonNode;
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
  var valid_579169 = path.getOrDefault("accountId")
  valid_579169 = validateParameter(valid_579169, JString, required = true,
                                 default = nil)
  if valid_579169 != nil:
    section.add "accountId", valid_579169
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  section = newJObject()
  var valid_579170 = query.getOrDefault("key")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "key", valid_579170
  var valid_579171 = query.getOrDefault("prettyPrint")
  valid_579171 = validateParameter(valid_579171, JBool, required = false,
                                 default = newJBool(true))
  if valid_579171 != nil:
    section.add "prettyPrint", valid_579171
  var valid_579172 = query.getOrDefault("oauth_token")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "oauth_token", valid_579172
  var valid_579173 = query.getOrDefault("alt")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = newJString("json"))
  if valid_579173 != nil:
    section.add "alt", valid_579173
  var valid_579174 = query.getOrDefault("userIp")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "userIp", valid_579174
  var valid_579175 = query.getOrDefault("quotaUser")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "quotaUser", valid_579175
  var valid_579176 = query.getOrDefault("pageToken")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "pageToken", valid_579176
  var valid_579177 = query.getOrDefault("fields")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "fields", valid_579177
  var valid_579178 = query.getOrDefault("maxResults")
  valid_579178 = validateParameter(valid_579178, JInt, required = false, default = nil)
  if valid_579178 != nil:
    section.add "maxResults", valid_579178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579179: Call_AdsenseAccountsSavedadstylesList_579166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_AdsenseAccountsSavedadstylesList_579166;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsenseAccountsSavedadstylesList
  ## List all saved ad styles in the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account for which to list saved ad styles.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "userIp", newJString(userIp))
  add(query_579182, "quotaUser", newJString(quotaUser))
  add(query_579182, "pageToken", newJString(pageToken))
  add(path_579181, "accountId", newJString(accountId))
  add(query_579182, "fields", newJString(fields))
  add(query_579182, "maxResults", newJInt(maxResults))
  result = call_579180.call(path_579181, query_579182, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_579166(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_579167,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesList_579168,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_579183 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsSavedadstylesGet_579185(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesGet_579184(path: JsonNode;
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
  var valid_579186 = path.getOrDefault("accountId")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "accountId", valid_579186
  var valid_579187 = path.getOrDefault("savedAdStyleId")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "savedAdStyleId", valid_579187
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579188 = query.getOrDefault("key")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "key", valid_579188
  var valid_579189 = query.getOrDefault("prettyPrint")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(true))
  if valid_579189 != nil:
    section.add "prettyPrint", valid_579189
  var valid_579190 = query.getOrDefault("oauth_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "oauth_token", valid_579190
  var valid_579191 = query.getOrDefault("alt")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("json"))
  if valid_579191 != nil:
    section.add "alt", valid_579191
  var valid_579192 = query.getOrDefault("userIp")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "userIp", valid_579192
  var valid_579193 = query.getOrDefault("quotaUser")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "quotaUser", valid_579193
  var valid_579194 = query.getOrDefault("fields")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "fields", valid_579194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579195: Call_AdsenseAccountsSavedadstylesGet_579183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_579195.validator(path, query, header, formData, body)
  let scheme = call_579195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579195.url(scheme.get, call_579195.host, call_579195.base,
                         call_579195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579195, url, valid)

proc call*(call_579196: Call_AdsenseAccountsSavedadstylesGet_579183;
          accountId: string; savedAdStyleId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAccountsSavedadstylesGet
  ## List a specific saved ad style for the specified account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   accountId: string (required)
  ##            : Account for which to get the saved ad style.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  var path_579197 = newJObject()
  var query_579198 = newJObject()
  add(query_579198, "key", newJString(key))
  add(query_579198, "prettyPrint", newJBool(prettyPrint))
  add(query_579198, "oauth_token", newJString(oauthToken))
  add(query_579198, "alt", newJString(alt))
  add(query_579198, "userIp", newJString(userIp))
  add(query_579198, "quotaUser", newJString(quotaUser))
  add(path_579197, "accountId", newJString(accountId))
  add(query_579198, "fields", newJString(fields))
  add(path_579197, "savedAdStyleId", newJString(savedAdStyleId))
  result = call_579196.call(path_579197, query_579198, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_579183(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_579184,
    base: "/adsense/v1.3", url: url_AdsenseAccountsSavedadstylesGet_579185,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_579199 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdclientsList_579201(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_579200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  section = newJObject()
  var valid_579202 = query.getOrDefault("key")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "key", valid_579202
  var valid_579203 = query.getOrDefault("prettyPrint")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(true))
  if valid_579203 != nil:
    section.add "prettyPrint", valid_579203
  var valid_579204 = query.getOrDefault("oauth_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "oauth_token", valid_579204
  var valid_579205 = query.getOrDefault("alt")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("json"))
  if valid_579205 != nil:
    section.add "alt", valid_579205
  var valid_579206 = query.getOrDefault("userIp")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "userIp", valid_579206
  var valid_579207 = query.getOrDefault("quotaUser")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "quotaUser", valid_579207
  var valid_579208 = query.getOrDefault("pageToken")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "pageToken", valid_579208
  var valid_579209 = query.getOrDefault("fields")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "fields", valid_579209
  var valid_579210 = query.getOrDefault("maxResults")
  valid_579210 = validateParameter(valid_579210, JInt, required = false, default = nil)
  if valid_579210 != nil:
    section.add "maxResults", valid_579210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579211: Call_AdsenseAdclientsList_579199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_579211.validator(path, query, header, formData, body)
  let scheme = call_579211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579211.url(scheme.get, call_579211.host, call_579211.base,
                         call_579211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579211, url, valid)

proc call*(call_579212: Call_AdsenseAdclientsList_579199; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAdclientsList
  ## List all ad clients in this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  var query_579213 = newJObject()
  add(query_579213, "key", newJString(key))
  add(query_579213, "prettyPrint", newJBool(prettyPrint))
  add(query_579213, "oauth_token", newJString(oauthToken))
  add(query_579213, "alt", newJString(alt))
  add(query_579213, "userIp", newJString(userIp))
  add(query_579213, "quotaUser", newJString(quotaUser))
  add(query_579213, "pageToken", newJString(pageToken))
  add(query_579213, "fields", newJString(fields))
  add(query_579213, "maxResults", newJInt(maxResults))
  result = call_579212.call(nil, query_579213, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_579199(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_579200, base: "/adsense/v1.3",
    url: url_AdsenseAdclientsList_579201, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_579214 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsList_579216(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsList_579215(path: JsonNode; query: JsonNode;
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
  var valid_579217 = path.getOrDefault("adClientId")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = nil)
  if valid_579217 != nil:
    section.add "adClientId", valid_579217
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_579218 = query.getOrDefault("key")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "key", valid_579218
  var valid_579219 = query.getOrDefault("prettyPrint")
  valid_579219 = validateParameter(valid_579219, JBool, required = false,
                                 default = newJBool(true))
  if valid_579219 != nil:
    section.add "prettyPrint", valid_579219
  var valid_579220 = query.getOrDefault("oauth_token")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "oauth_token", valid_579220
  var valid_579221 = query.getOrDefault("alt")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = newJString("json"))
  if valid_579221 != nil:
    section.add "alt", valid_579221
  var valid_579222 = query.getOrDefault("userIp")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "userIp", valid_579222
  var valid_579223 = query.getOrDefault("quotaUser")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "quotaUser", valid_579223
  var valid_579224 = query.getOrDefault("pageToken")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "pageToken", valid_579224
  var valid_579225 = query.getOrDefault("includeInactive")
  valid_579225 = validateParameter(valid_579225, JBool, required = false, default = nil)
  if valid_579225 != nil:
    section.add "includeInactive", valid_579225
  var valid_579226 = query.getOrDefault("fields")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "fields", valid_579226
  var valid_579227 = query.getOrDefault("maxResults")
  valid_579227 = validateParameter(valid_579227, JInt, required = false, default = nil)
  if valid_579227 != nil:
    section.add "maxResults", valid_579227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579228: Call_AdsenseAdunitsList_579214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_579228.validator(path, query, header, formData, body)
  let scheme = call_579228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579228.url(scheme.get, call_579228.host, call_579228.base,
                         call_579228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579228, url, valid)

proc call*(call_579229: Call_AdsenseAdunitsList_579214; adClientId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; includeInactive: bool = false; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsenseAdunitsList
  ## List all ad units in the specified ad client for this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list ad units.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_579230 = newJObject()
  var query_579231 = newJObject()
  add(query_579231, "key", newJString(key))
  add(query_579231, "prettyPrint", newJBool(prettyPrint))
  add(query_579231, "oauth_token", newJString(oauthToken))
  add(query_579231, "alt", newJString(alt))
  add(query_579231, "userIp", newJString(userIp))
  add(query_579231, "quotaUser", newJString(quotaUser))
  add(query_579231, "pageToken", newJString(pageToken))
  add(path_579230, "adClientId", newJString(adClientId))
  add(query_579231, "includeInactive", newJBool(includeInactive))
  add(query_579231, "fields", newJString(fields))
  add(query_579231, "maxResults", newJInt(maxResults))
  result = call_579229.call(path_579230, query_579231, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_579214(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_579215, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsList_579216, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_579232 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsGet_579234(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGet_579233(path: JsonNode; query: JsonNode;
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
  var valid_579235 = path.getOrDefault("adClientId")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "adClientId", valid_579235
  var valid_579236 = path.getOrDefault("adUnitId")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "adUnitId", valid_579236
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579237 = query.getOrDefault("key")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "key", valid_579237
  var valid_579238 = query.getOrDefault("prettyPrint")
  valid_579238 = validateParameter(valid_579238, JBool, required = false,
                                 default = newJBool(true))
  if valid_579238 != nil:
    section.add "prettyPrint", valid_579238
  var valid_579239 = query.getOrDefault("oauth_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "oauth_token", valid_579239
  var valid_579240 = query.getOrDefault("alt")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = newJString("json"))
  if valid_579240 != nil:
    section.add "alt", valid_579240
  var valid_579241 = query.getOrDefault("userIp")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "userIp", valid_579241
  var valid_579242 = query.getOrDefault("quotaUser")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "quotaUser", valid_579242
  var valid_579243 = query.getOrDefault("fields")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "fields", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579244: Call_AdsenseAdunitsGet_579232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_579244.validator(path, query, header, formData, body)
  let scheme = call_579244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579244.url(scheme.get, call_579244.host, call_579244.base,
                         call_579244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579244, url, valid)

proc call*(call_579245: Call_AdsenseAdunitsGet_579232; adClientId: string;
          adUnitId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAdunitsGet
  ## Gets the specified ad unit in the specified ad client.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579246 = newJObject()
  var query_579247 = newJObject()
  add(query_579247, "key", newJString(key))
  add(query_579247, "prettyPrint", newJBool(prettyPrint))
  add(query_579247, "oauth_token", newJString(oauthToken))
  add(query_579247, "alt", newJString(alt))
  add(query_579247, "userIp", newJString(userIp))
  add(query_579247, "quotaUser", newJString(quotaUser))
  add(path_579246, "adClientId", newJString(adClientId))
  add(path_579246, "adUnitId", newJString(adUnitId))
  add(query_579247, "fields", newJString(fields))
  result = call_579245.call(path_579246, query_579247, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_579232(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_579233, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGet_579234, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_579248 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsGetAdCode_579250(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGetAdCode_579249(path: JsonNode; query: JsonNode;
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
  var valid_579251 = path.getOrDefault("adClientId")
  valid_579251 = validateParameter(valid_579251, JString, required = true,
                                 default = nil)
  if valid_579251 != nil:
    section.add "adClientId", valid_579251
  var valid_579252 = path.getOrDefault("adUnitId")
  valid_579252 = validateParameter(valid_579252, JString, required = true,
                                 default = nil)
  if valid_579252 != nil:
    section.add "adUnitId", valid_579252
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579253 = query.getOrDefault("key")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "key", valid_579253
  var valid_579254 = query.getOrDefault("prettyPrint")
  valid_579254 = validateParameter(valid_579254, JBool, required = false,
                                 default = newJBool(true))
  if valid_579254 != nil:
    section.add "prettyPrint", valid_579254
  var valid_579255 = query.getOrDefault("oauth_token")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "oauth_token", valid_579255
  var valid_579256 = query.getOrDefault("alt")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = newJString("json"))
  if valid_579256 != nil:
    section.add "alt", valid_579256
  var valid_579257 = query.getOrDefault("userIp")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "userIp", valid_579257
  var valid_579258 = query.getOrDefault("quotaUser")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "quotaUser", valid_579258
  var valid_579259 = query.getOrDefault("fields")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "fields", valid_579259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579260: Call_AdsenseAdunitsGetAdCode_579248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_579260.validator(path, query, header, formData, body)
  let scheme = call_579260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579260.url(scheme.get, call_579260.host, call_579260.base,
                         call_579260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579260, url, valid)

proc call*(call_579261: Call_AdsenseAdunitsGetAdCode_579248; adClientId: string;
          adUnitId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAdunitsGetAdCode
  ## Get ad code for the specified ad unit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579262 = newJObject()
  var query_579263 = newJObject()
  add(query_579263, "key", newJString(key))
  add(query_579263, "prettyPrint", newJBool(prettyPrint))
  add(query_579263, "oauth_token", newJString(oauthToken))
  add(query_579263, "alt", newJString(alt))
  add(query_579263, "userIp", newJString(userIp))
  add(query_579263, "quotaUser", newJString(quotaUser))
  add(path_579262, "adClientId", newJString(adClientId))
  add(path_579262, "adUnitId", newJString(adUnitId))
  add(query_579263, "fields", newJString(fields))
  result = call_579261.call(path_579262, query_579263, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_579248(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_579249, base: "/adsense/v1.3",
    url: url_AdsenseAdunitsGetAdCode_579250, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_579264 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsCustomchannelsList_579266(protocol: Scheme; host: string;
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

proc validate_AdsenseAdunitsCustomchannelsList_579265(path: JsonNode;
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
  var valid_579267 = path.getOrDefault("adClientId")
  valid_579267 = validateParameter(valid_579267, JString, required = true,
                                 default = nil)
  if valid_579267 != nil:
    section.add "adClientId", valid_579267
  var valid_579268 = path.getOrDefault("adUnitId")
  valid_579268 = validateParameter(valid_579268, JString, required = true,
                                 default = nil)
  if valid_579268 != nil:
    section.add "adUnitId", valid_579268
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579269 = query.getOrDefault("key")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "key", valid_579269
  var valid_579270 = query.getOrDefault("prettyPrint")
  valid_579270 = validateParameter(valid_579270, JBool, required = false,
                                 default = newJBool(true))
  if valid_579270 != nil:
    section.add "prettyPrint", valid_579270
  var valid_579271 = query.getOrDefault("oauth_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "oauth_token", valid_579271
  var valid_579272 = query.getOrDefault("alt")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = newJString("json"))
  if valid_579272 != nil:
    section.add "alt", valid_579272
  var valid_579273 = query.getOrDefault("userIp")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "userIp", valid_579273
  var valid_579274 = query.getOrDefault("quotaUser")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "quotaUser", valid_579274
  var valid_579275 = query.getOrDefault("pageToken")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "pageToken", valid_579275
  var valid_579276 = query.getOrDefault("fields")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "fields", valid_579276
  var valid_579277 = query.getOrDefault("maxResults")
  valid_579277 = validateParameter(valid_579277, JInt, required = false, default = nil)
  if valid_579277 != nil:
    section.add "maxResults", valid_579277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579278: Call_AdsenseAdunitsCustomchannelsList_579264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_579278.validator(path, query, header, formData, body)
  let scheme = call_579278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579278.url(scheme.get, call_579278.host, call_579278.base,
                         call_579278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579278, url, valid)

proc call*(call_579279: Call_AdsenseAdunitsCustomchannelsList_579264;
          adClientId: string; adUnitId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseAdunitsCustomchannelsList
  ## List all custom channels which the specified ad unit belongs to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client which contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit for which to list custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_579280 = newJObject()
  var query_579281 = newJObject()
  add(query_579281, "key", newJString(key))
  add(query_579281, "prettyPrint", newJBool(prettyPrint))
  add(query_579281, "oauth_token", newJString(oauthToken))
  add(query_579281, "alt", newJString(alt))
  add(query_579281, "userIp", newJString(userIp))
  add(query_579281, "quotaUser", newJString(quotaUser))
  add(query_579281, "pageToken", newJString(pageToken))
  add(path_579280, "adClientId", newJString(adClientId))
  add(path_579280, "adUnitId", newJString(adUnitId))
  add(query_579281, "fields", newJString(fields))
  add(query_579281, "maxResults", newJInt(maxResults))
  result = call_579279.call(path_579280, query_579281, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_579264(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_579265,
    base: "/adsense/v1.3", url: url_AdsenseAdunitsCustomchannelsList_579266,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_579282 = ref object of OpenApiRestCall_578355
proc url_AdsenseCustomchannelsList_579284(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsList_579283(path: JsonNode; query: JsonNode;
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
  var valid_579285 = path.getOrDefault("adClientId")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "adClientId", valid_579285
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579286 = query.getOrDefault("key")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "key", valid_579286
  var valid_579287 = query.getOrDefault("prettyPrint")
  valid_579287 = validateParameter(valid_579287, JBool, required = false,
                                 default = newJBool(true))
  if valid_579287 != nil:
    section.add "prettyPrint", valid_579287
  var valid_579288 = query.getOrDefault("oauth_token")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "oauth_token", valid_579288
  var valid_579289 = query.getOrDefault("alt")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("json"))
  if valid_579289 != nil:
    section.add "alt", valid_579289
  var valid_579290 = query.getOrDefault("userIp")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "userIp", valid_579290
  var valid_579291 = query.getOrDefault("quotaUser")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "quotaUser", valid_579291
  var valid_579292 = query.getOrDefault("pageToken")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "pageToken", valid_579292
  var valid_579293 = query.getOrDefault("fields")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "fields", valid_579293
  var valid_579294 = query.getOrDefault("maxResults")
  valid_579294 = validateParameter(valid_579294, JInt, required = false, default = nil)
  if valid_579294 != nil:
    section.add "maxResults", valid_579294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579295: Call_AdsenseCustomchannelsList_579282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_579295.validator(path, query, header, formData, body)
  let scheme = call_579295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579295.url(scheme.get, call_579295.host, call_579295.base,
                         call_579295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579295, url, valid)

proc call*(call_579296: Call_AdsenseCustomchannelsList_579282; adClientId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseCustomchannelsList
  ## List all custom channels in the specified ad client for this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_579297 = newJObject()
  var query_579298 = newJObject()
  add(query_579298, "key", newJString(key))
  add(query_579298, "prettyPrint", newJBool(prettyPrint))
  add(query_579298, "oauth_token", newJString(oauthToken))
  add(query_579298, "alt", newJString(alt))
  add(query_579298, "userIp", newJString(userIp))
  add(query_579298, "quotaUser", newJString(quotaUser))
  add(query_579298, "pageToken", newJString(pageToken))
  add(path_579297, "adClientId", newJString(adClientId))
  add(query_579298, "fields", newJString(fields))
  add(query_579298, "maxResults", newJInt(maxResults))
  result = call_579296.call(path_579297, query_579298, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_579282(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_579283, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsList_579284, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_579299 = ref object of OpenApiRestCall_578355
proc url_AdsenseCustomchannelsGet_579301(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsGet_579300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified custom channel from the specified ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579302 = path.getOrDefault("adClientId")
  valid_579302 = validateParameter(valid_579302, JString, required = true,
                                 default = nil)
  if valid_579302 != nil:
    section.add "adClientId", valid_579302
  var valid_579303 = path.getOrDefault("customChannelId")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "customChannelId", valid_579303
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579304 = query.getOrDefault("key")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "key", valid_579304
  var valid_579305 = query.getOrDefault("prettyPrint")
  valid_579305 = validateParameter(valid_579305, JBool, required = false,
                                 default = newJBool(true))
  if valid_579305 != nil:
    section.add "prettyPrint", valid_579305
  var valid_579306 = query.getOrDefault("oauth_token")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "oauth_token", valid_579306
  var valid_579307 = query.getOrDefault("alt")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = newJString("json"))
  if valid_579307 != nil:
    section.add "alt", valid_579307
  var valid_579308 = query.getOrDefault("userIp")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "userIp", valid_579308
  var valid_579309 = query.getOrDefault("quotaUser")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "quotaUser", valid_579309
  var valid_579310 = query.getOrDefault("fields")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "fields", valid_579310
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579311: Call_AdsenseCustomchannelsGet_579299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_579311.validator(path, query, header, formData, body)
  let scheme = call_579311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579311.url(scheme.get, call_579311.host, call_579311.base,
                         call_579311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579311, url, valid)

proc call*(call_579312: Call_AdsenseCustomchannelsGet_579299; adClientId: string;
          customChannelId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseCustomchannelsGet
  ## Get the specified custom channel from the specified ad client.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579313 = newJObject()
  var query_579314 = newJObject()
  add(query_579314, "key", newJString(key))
  add(query_579314, "prettyPrint", newJBool(prettyPrint))
  add(query_579314, "oauth_token", newJString(oauthToken))
  add(query_579314, "alt", newJString(alt))
  add(query_579314, "userIp", newJString(userIp))
  add(query_579314, "quotaUser", newJString(quotaUser))
  add(path_579313, "adClientId", newJString(adClientId))
  add(path_579313, "customChannelId", newJString(customChannelId))
  add(query_579314, "fields", newJString(fields))
  result = call_579312.call(path_579313, query_579314, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_579299(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_579300, base: "/adsense/v1.3",
    url: url_AdsenseCustomchannelsGet_579301, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_579315 = ref object of OpenApiRestCall_578355
proc url_AdsenseCustomchannelsAdunitsList_579317(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsAdunitsList_579316(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified custom channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: JString (required)
  ##                  : Custom channel for which to list ad units.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579318 = path.getOrDefault("adClientId")
  valid_579318 = validateParameter(valid_579318, JString, required = true,
                                 default = nil)
  if valid_579318 != nil:
    section.add "adClientId", valid_579318
  var valid_579319 = path.getOrDefault("customChannelId")
  valid_579319 = validateParameter(valid_579319, JString, required = true,
                                 default = nil)
  if valid_579319 != nil:
    section.add "customChannelId", valid_579319
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_579320 = query.getOrDefault("key")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "key", valid_579320
  var valid_579321 = query.getOrDefault("prettyPrint")
  valid_579321 = validateParameter(valid_579321, JBool, required = false,
                                 default = newJBool(true))
  if valid_579321 != nil:
    section.add "prettyPrint", valid_579321
  var valid_579322 = query.getOrDefault("oauth_token")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "oauth_token", valid_579322
  var valid_579323 = query.getOrDefault("alt")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = newJString("json"))
  if valid_579323 != nil:
    section.add "alt", valid_579323
  var valid_579324 = query.getOrDefault("userIp")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "userIp", valid_579324
  var valid_579325 = query.getOrDefault("quotaUser")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "quotaUser", valid_579325
  var valid_579326 = query.getOrDefault("pageToken")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "pageToken", valid_579326
  var valid_579327 = query.getOrDefault("includeInactive")
  valid_579327 = validateParameter(valid_579327, JBool, required = false, default = nil)
  if valid_579327 != nil:
    section.add "includeInactive", valid_579327
  var valid_579328 = query.getOrDefault("fields")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "fields", valid_579328
  var valid_579329 = query.getOrDefault("maxResults")
  valid_579329 = validateParameter(valid_579329, JInt, required = false, default = nil)
  if valid_579329 != nil:
    section.add "maxResults", valid_579329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579330: Call_AdsenseCustomchannelsAdunitsList_579315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_579330.validator(path, query, header, formData, body)
  let scheme = call_579330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579330.url(scheme.get, call_579330.host, call_579330.base,
                         call_579330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579330, url, valid)

proc call*(call_579331: Call_AdsenseCustomchannelsAdunitsList_579315;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          includeInactive: bool = false; fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseCustomchannelsAdunitsList
  ## List all ad units in the specified custom channel.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel for which to list ad units.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_579332 = newJObject()
  var query_579333 = newJObject()
  add(query_579333, "key", newJString(key))
  add(query_579333, "prettyPrint", newJBool(prettyPrint))
  add(query_579333, "oauth_token", newJString(oauthToken))
  add(query_579333, "alt", newJString(alt))
  add(query_579333, "userIp", newJString(userIp))
  add(query_579333, "quotaUser", newJString(quotaUser))
  add(query_579333, "pageToken", newJString(pageToken))
  add(path_579332, "adClientId", newJString(adClientId))
  add(path_579332, "customChannelId", newJString(customChannelId))
  add(query_579333, "includeInactive", newJBool(includeInactive))
  add(query_579333, "fields", newJString(fields))
  add(query_579333, "maxResults", newJInt(maxResults))
  result = call_579331.call(path_579332, query_579333, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_579315(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_579316,
    base: "/adsense/v1.3", url: url_AdsenseCustomchannelsAdunitsList_579317,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_579334 = ref object of OpenApiRestCall_578355
proc url_AdsenseUrlchannelsList_579336(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseUrlchannelsList_579335(path: JsonNode; query: JsonNode;
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
  var valid_579337 = path.getOrDefault("adClientId")
  valid_579337 = validateParameter(valid_579337, JString, required = true,
                                 default = nil)
  if valid_579337 != nil:
    section.add "adClientId", valid_579337
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  section = newJObject()
  var valid_579338 = query.getOrDefault("key")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "key", valid_579338
  var valid_579339 = query.getOrDefault("prettyPrint")
  valid_579339 = validateParameter(valid_579339, JBool, required = false,
                                 default = newJBool(true))
  if valid_579339 != nil:
    section.add "prettyPrint", valid_579339
  var valid_579340 = query.getOrDefault("oauth_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "oauth_token", valid_579340
  var valid_579341 = query.getOrDefault("alt")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("json"))
  if valid_579341 != nil:
    section.add "alt", valid_579341
  var valid_579342 = query.getOrDefault("userIp")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "userIp", valid_579342
  var valid_579343 = query.getOrDefault("quotaUser")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "quotaUser", valid_579343
  var valid_579344 = query.getOrDefault("pageToken")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "pageToken", valid_579344
  var valid_579345 = query.getOrDefault("fields")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "fields", valid_579345
  var valid_579346 = query.getOrDefault("maxResults")
  valid_579346 = validateParameter(valid_579346, JInt, required = false, default = nil)
  if valid_579346 != nil:
    section.add "maxResults", valid_579346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579347: Call_AdsenseUrlchannelsList_579334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_579347.validator(path, query, header, formData, body)
  let scheme = call_579347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579347.url(scheme.get, call_579347.host, call_579347.base,
                         call_579347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579347, url, valid)

proc call*(call_579348: Call_AdsenseUrlchannelsList_579334; adClientId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseUrlchannelsList
  ## List all URL channels in the specified ad client for this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  var path_579349 = newJObject()
  var query_579350 = newJObject()
  add(query_579350, "key", newJString(key))
  add(query_579350, "prettyPrint", newJBool(prettyPrint))
  add(query_579350, "oauth_token", newJString(oauthToken))
  add(query_579350, "alt", newJString(alt))
  add(query_579350, "userIp", newJString(userIp))
  add(query_579350, "quotaUser", newJString(quotaUser))
  add(query_579350, "pageToken", newJString(pageToken))
  add(path_579349, "adClientId", newJString(adClientId))
  add(query_579350, "fields", newJString(fields))
  add(query_579350, "maxResults", newJInt(maxResults))
  result = call_579348.call(path_579349, query_579350, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_579334(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_579335, base: "/adsense/v1.3",
    url: url_AdsenseUrlchannelsList_579336, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_579351 = ref object of OpenApiRestCall_578355
proc url_AdsenseAlertsList_579353(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_579352(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List the alerts for this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579354 = query.getOrDefault("key")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "key", valid_579354
  var valid_579355 = query.getOrDefault("prettyPrint")
  valid_579355 = validateParameter(valid_579355, JBool, required = false,
                                 default = newJBool(true))
  if valid_579355 != nil:
    section.add "prettyPrint", valid_579355
  var valid_579356 = query.getOrDefault("oauth_token")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "oauth_token", valid_579356
  var valid_579357 = query.getOrDefault("locale")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "locale", valid_579357
  var valid_579358 = query.getOrDefault("alt")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = newJString("json"))
  if valid_579358 != nil:
    section.add "alt", valid_579358
  var valid_579359 = query.getOrDefault("userIp")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "userIp", valid_579359
  var valid_579360 = query.getOrDefault("quotaUser")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "quotaUser", valid_579360
  var valid_579361 = query.getOrDefault("fields")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "fields", valid_579361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579362: Call_AdsenseAlertsList_579351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_579362.validator(path, query, header, formData, body)
  let scheme = call_579362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579362.url(scheme.get, call_579362.host, call_579362.base,
                         call_579362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579362, url, valid)

proc call*(call_579363: Call_AdsenseAlertsList_579351; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsenseAlertsList
  ## List the alerts for this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579364 = newJObject()
  add(query_579364, "key", newJString(key))
  add(query_579364, "prettyPrint", newJBool(prettyPrint))
  add(query_579364, "oauth_token", newJString(oauthToken))
  add(query_579364, "locale", newJString(locale))
  add(query_579364, "alt", newJString(alt))
  add(query_579364, "userIp", newJString(userIp))
  add(query_579364, "quotaUser", newJString(quotaUser))
  add(query_579364, "fields", newJString(fields))
  result = call_579363.call(nil, query_579364, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_579351(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_579352, base: "/adsense/v1.3",
    url: url_AdsenseAlertsList_579353, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_579365 = ref object of OpenApiRestCall_578355
proc url_AdsenseMetadataDimensionsList_579367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_579366(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579368 = query.getOrDefault("key")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "key", valid_579368
  var valid_579369 = query.getOrDefault("prettyPrint")
  valid_579369 = validateParameter(valid_579369, JBool, required = false,
                                 default = newJBool(true))
  if valid_579369 != nil:
    section.add "prettyPrint", valid_579369
  var valid_579370 = query.getOrDefault("oauth_token")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "oauth_token", valid_579370
  var valid_579371 = query.getOrDefault("alt")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = newJString("json"))
  if valid_579371 != nil:
    section.add "alt", valid_579371
  var valid_579372 = query.getOrDefault("userIp")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "userIp", valid_579372
  var valid_579373 = query.getOrDefault("quotaUser")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "quotaUser", valid_579373
  var valid_579374 = query.getOrDefault("fields")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "fields", valid_579374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579375: Call_AdsenseMetadataDimensionsList_579365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_579375.validator(path, query, header, formData, body)
  let scheme = call_579375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579375.url(scheme.get, call_579375.host, call_579375.base,
                         call_579375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579375, url, valid)

proc call*(call_579376: Call_AdsenseMetadataDimensionsList_579365;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsenseMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579377 = newJObject()
  add(query_579377, "key", newJString(key))
  add(query_579377, "prettyPrint", newJBool(prettyPrint))
  add(query_579377, "oauth_token", newJString(oauthToken))
  add(query_579377, "alt", newJString(alt))
  add(query_579377, "userIp", newJString(userIp))
  add(query_579377, "quotaUser", newJString(quotaUser))
  add(query_579377, "fields", newJString(fields))
  result = call_579376.call(nil, query_579377, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_579365(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_579366,
    base: "/adsense/v1.3", url: url_AdsenseMetadataDimensionsList_579367,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_579378 = ref object of OpenApiRestCall_578355
proc url_AdsenseMetadataMetricsList_579380(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_579379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579381 = query.getOrDefault("key")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "key", valid_579381
  var valid_579382 = query.getOrDefault("prettyPrint")
  valid_579382 = validateParameter(valid_579382, JBool, required = false,
                                 default = newJBool(true))
  if valid_579382 != nil:
    section.add "prettyPrint", valid_579382
  var valid_579383 = query.getOrDefault("oauth_token")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "oauth_token", valid_579383
  var valid_579384 = query.getOrDefault("alt")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = newJString("json"))
  if valid_579384 != nil:
    section.add "alt", valid_579384
  var valid_579385 = query.getOrDefault("userIp")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "userIp", valid_579385
  var valid_579386 = query.getOrDefault("quotaUser")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "quotaUser", valid_579386
  var valid_579387 = query.getOrDefault("fields")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "fields", valid_579387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579388: Call_AdsenseMetadataMetricsList_579378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_579388.validator(path, query, header, formData, body)
  let scheme = call_579388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579388.url(scheme.get, call_579388.host, call_579388.base,
                         call_579388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579388, url, valid)

proc call*(call_579389: Call_AdsenseMetadataMetricsList_579378; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseMetadataMetricsList
  ## List the metadata for the metrics available to this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579390 = newJObject()
  add(query_579390, "key", newJString(key))
  add(query_579390, "prettyPrint", newJBool(prettyPrint))
  add(query_579390, "oauth_token", newJString(oauthToken))
  add(query_579390, "alt", newJString(alt))
  add(query_579390, "userIp", newJString(userIp))
  add(query_579390, "quotaUser", newJString(quotaUser))
  add(query_579390, "fields", newJString(fields))
  result = call_579389.call(nil, query_579390, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_579378(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_579379, base: "/adsense/v1.3",
    url: url_AdsenseMetadataMetricsList_579380, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_579391 = ref object of OpenApiRestCall_578355
proc url_AdsenseReportsGenerate_579393(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_579392(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   currency: JString
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   useTimezoneReporting: JBool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   accountId: JArray
  ##            : Accounts upon which to report.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  section = newJObject()
  var valid_579394 = query.getOrDefault("key")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "key", valid_579394
  var valid_579395 = query.getOrDefault("prettyPrint")
  valid_579395 = validateParameter(valid_579395, JBool, required = false,
                                 default = newJBool(true))
  if valid_579395 != nil:
    section.add "prettyPrint", valid_579395
  var valid_579396 = query.getOrDefault("oauth_token")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "oauth_token", valid_579396
  var valid_579397 = query.getOrDefault("locale")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "locale", valid_579397
  var valid_579398 = query.getOrDefault("currency")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "currency", valid_579398
  var valid_579399 = query.getOrDefault("alt")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = newJString("json"))
  if valid_579399 != nil:
    section.add "alt", valid_579399
  var valid_579400 = query.getOrDefault("userIp")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "userIp", valid_579400
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579401 = query.getOrDefault("endDate")
  valid_579401 = validateParameter(valid_579401, JString, required = true,
                                 default = nil)
  if valid_579401 != nil:
    section.add "endDate", valid_579401
  var valid_579402 = query.getOrDefault("quotaUser")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "quotaUser", valid_579402
  var valid_579403 = query.getOrDefault("startIndex")
  valid_579403 = validateParameter(valid_579403, JInt, required = false, default = nil)
  if valid_579403 != nil:
    section.add "startIndex", valid_579403
  var valid_579404 = query.getOrDefault("filter")
  valid_579404 = validateParameter(valid_579404, JArray, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "filter", valid_579404
  var valid_579405 = query.getOrDefault("useTimezoneReporting")
  valid_579405 = validateParameter(valid_579405, JBool, required = false, default = nil)
  if valid_579405 != nil:
    section.add "useTimezoneReporting", valid_579405
  var valid_579406 = query.getOrDefault("dimension")
  valid_579406 = validateParameter(valid_579406, JArray, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "dimension", valid_579406
  var valid_579407 = query.getOrDefault("metric")
  valid_579407 = validateParameter(valid_579407, JArray, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "metric", valid_579407
  var valid_579408 = query.getOrDefault("fields")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "fields", valid_579408
  var valid_579409 = query.getOrDefault("startDate")
  valid_579409 = validateParameter(valid_579409, JString, required = true,
                                 default = nil)
  if valid_579409 != nil:
    section.add "startDate", valid_579409
  var valid_579410 = query.getOrDefault("accountId")
  valid_579410 = validateParameter(valid_579410, JArray, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "accountId", valid_579410
  var valid_579411 = query.getOrDefault("maxResults")
  valid_579411 = validateParameter(valid_579411, JInt, required = false, default = nil)
  if valid_579411 != nil:
    section.add "maxResults", valid_579411
  var valid_579412 = query.getOrDefault("sort")
  valid_579412 = validateParameter(valid_579412, JArray, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "sort", valid_579412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579413: Call_AdsenseReportsGenerate_579391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579413.validator(path, query, header, formData, body)
  let scheme = call_579413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579413.url(scheme.get, call_579413.host, call_579413.base,
                         call_579413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579413, url, valid)

proc call*(call_579414: Call_AdsenseReportsGenerate_579391; endDate: string;
          startDate: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; currency: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; filter: JsonNode = nil;
          useTimezoneReporting: bool = false; dimension: JsonNode = nil;
          metric: JsonNode = nil; fields: string = ""; accountId: JsonNode = nil;
          maxResults: int = 0; sort: JsonNode = nil): Recallable =
  ## adsenseReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   currency: string
  ##           : Optional currency to use when reporting on monetary metrics. Defaults to the account's currency if not set.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   useTimezoneReporting: bool
  ##                       : Whether the report should be generated in the AdSense account's local timezone. If false default PST/PDT timezone will be used.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   metric: JArray
  ##         : Numeric columns to include in the report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string (required)
  ##            : Start of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   accountId: JArray
  ##            : Accounts upon which to report.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  ##   sort: JArray
  ##       : The name of a dimension or metric to sort the resulting report on, optionally prefixed with "+" to sort ascending or "-" to sort descending. If no prefix is specified, the column is sorted ascending.
  var query_579415 = newJObject()
  add(query_579415, "key", newJString(key))
  add(query_579415, "prettyPrint", newJBool(prettyPrint))
  add(query_579415, "oauth_token", newJString(oauthToken))
  add(query_579415, "locale", newJString(locale))
  add(query_579415, "currency", newJString(currency))
  add(query_579415, "alt", newJString(alt))
  add(query_579415, "userIp", newJString(userIp))
  add(query_579415, "endDate", newJString(endDate))
  add(query_579415, "quotaUser", newJString(quotaUser))
  add(query_579415, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579415.add "filter", filter
  add(query_579415, "useTimezoneReporting", newJBool(useTimezoneReporting))
  if dimension != nil:
    query_579415.add "dimension", dimension
  if metric != nil:
    query_579415.add "metric", metric
  add(query_579415, "fields", newJString(fields))
  add(query_579415, "startDate", newJString(startDate))
  if accountId != nil:
    query_579415.add "accountId", accountId
  add(query_579415, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579415.add "sort", sort
  result = call_579414.call(nil, query_579415, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_579391(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_579392, base: "/adsense/v1.3",
    url: url_AdsenseReportsGenerate_579393, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_579416 = ref object of OpenApiRestCall_578355
proc url_AdsenseReportsSavedList_579418(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_579417(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  section = newJObject()
  var valid_579419 = query.getOrDefault("key")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "key", valid_579419
  var valid_579420 = query.getOrDefault("prettyPrint")
  valid_579420 = validateParameter(valid_579420, JBool, required = false,
                                 default = newJBool(true))
  if valid_579420 != nil:
    section.add "prettyPrint", valid_579420
  var valid_579421 = query.getOrDefault("oauth_token")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "oauth_token", valid_579421
  var valid_579422 = query.getOrDefault("alt")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = newJString("json"))
  if valid_579422 != nil:
    section.add "alt", valid_579422
  var valid_579423 = query.getOrDefault("userIp")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "userIp", valid_579423
  var valid_579424 = query.getOrDefault("quotaUser")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "quotaUser", valid_579424
  var valid_579425 = query.getOrDefault("pageToken")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "pageToken", valid_579425
  var valid_579426 = query.getOrDefault("fields")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "fields", valid_579426
  var valid_579427 = query.getOrDefault("maxResults")
  valid_579427 = validateParameter(valid_579427, JInt, required = false, default = nil)
  if valid_579427 != nil:
    section.add "maxResults", valid_579427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579428: Call_AdsenseReportsSavedList_579416; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_579428.validator(path, query, header, formData, body)
  let scheme = call_579428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579428.url(scheme.get, call_579428.host, call_579428.base,
                         call_579428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579428, url, valid)

proc call*(call_579429: Call_AdsenseReportsSavedList_579416; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseReportsSavedList
  ## List all saved reports in this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  var query_579430 = newJObject()
  add(query_579430, "key", newJString(key))
  add(query_579430, "prettyPrint", newJBool(prettyPrint))
  add(query_579430, "oauth_token", newJString(oauthToken))
  add(query_579430, "alt", newJString(alt))
  add(query_579430, "userIp", newJString(userIp))
  add(query_579430, "quotaUser", newJString(quotaUser))
  add(query_579430, "pageToken", newJString(pageToken))
  add(query_579430, "fields", newJString(fields))
  add(query_579430, "maxResults", newJInt(maxResults))
  result = call_579429.call(nil, query_579430, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_579416(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_579417, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedList_579418, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_579431 = ref object of OpenApiRestCall_578355
proc url_AdsenseReportsSavedGenerate_579433(protocol: Scheme; host: string;
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

proc validate_AdsenseReportsSavedGenerate_579432(path: JsonNode; query: JsonNode;
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
  var valid_579434 = path.getOrDefault("savedReportId")
  valid_579434 = validateParameter(valid_579434, JString, required = true,
                                 default = nil)
  if valid_579434 != nil:
    section.add "savedReportId", valid_579434
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locale: JString
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  section = newJObject()
  var valid_579435 = query.getOrDefault("key")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "key", valid_579435
  var valid_579436 = query.getOrDefault("prettyPrint")
  valid_579436 = validateParameter(valid_579436, JBool, required = false,
                                 default = newJBool(true))
  if valid_579436 != nil:
    section.add "prettyPrint", valid_579436
  var valid_579437 = query.getOrDefault("oauth_token")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "oauth_token", valid_579437
  var valid_579438 = query.getOrDefault("locale")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "locale", valid_579438
  var valid_579439 = query.getOrDefault("alt")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = newJString("json"))
  if valid_579439 != nil:
    section.add "alt", valid_579439
  var valid_579440 = query.getOrDefault("userIp")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "userIp", valid_579440
  var valid_579441 = query.getOrDefault("quotaUser")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "quotaUser", valid_579441
  var valid_579442 = query.getOrDefault("startIndex")
  valid_579442 = validateParameter(valid_579442, JInt, required = false, default = nil)
  if valid_579442 != nil:
    section.add "startIndex", valid_579442
  var valid_579443 = query.getOrDefault("fields")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "fields", valid_579443
  var valid_579444 = query.getOrDefault("maxResults")
  valid_579444 = validateParameter(valid_579444, JInt, required = false, default = nil)
  if valid_579444 != nil:
    section.add "maxResults", valid_579444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579445: Call_AdsenseReportsSavedGenerate_579431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579445.validator(path, query, header, formData, body)
  let scheme = call_579445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579445.url(scheme.get, call_579445.host, call_579445.base,
                         call_579445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579445, url, valid)

proc call*(call_579446: Call_AdsenseReportsSavedGenerate_579431;
          savedReportId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseReportsSavedGenerate
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locale: string
  ##         : Optional locale to use for translating report output to a local language. Defaults to "en_US" if not specified.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  var path_579447 = newJObject()
  var query_579448 = newJObject()
  add(query_579448, "key", newJString(key))
  add(query_579448, "prettyPrint", newJBool(prettyPrint))
  add(query_579448, "oauth_token", newJString(oauthToken))
  add(query_579448, "locale", newJString(locale))
  add(query_579448, "alt", newJString(alt))
  add(query_579448, "userIp", newJString(userIp))
  add(path_579447, "savedReportId", newJString(savedReportId))
  add(query_579448, "quotaUser", newJString(quotaUser))
  add(query_579448, "startIndex", newJInt(startIndex))
  add(query_579448, "fields", newJString(fields))
  add(query_579448, "maxResults", newJInt(maxResults))
  result = call_579446.call(path_579447, query_579448, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_579431(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_579432, base: "/adsense/v1.3",
    url: url_AdsenseReportsSavedGenerate_579433, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_579449 = ref object of OpenApiRestCall_578355
proc url_AdsenseSavedadstylesList_579451(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_579450(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved ad styles in the user's account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  section = newJObject()
  var valid_579452 = query.getOrDefault("key")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "key", valid_579452
  var valid_579453 = query.getOrDefault("prettyPrint")
  valid_579453 = validateParameter(valid_579453, JBool, required = false,
                                 default = newJBool(true))
  if valid_579453 != nil:
    section.add "prettyPrint", valid_579453
  var valid_579454 = query.getOrDefault("oauth_token")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "oauth_token", valid_579454
  var valid_579455 = query.getOrDefault("alt")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = newJString("json"))
  if valid_579455 != nil:
    section.add "alt", valid_579455
  var valid_579456 = query.getOrDefault("userIp")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "userIp", valid_579456
  var valid_579457 = query.getOrDefault("quotaUser")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "quotaUser", valid_579457
  var valid_579458 = query.getOrDefault("pageToken")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "pageToken", valid_579458
  var valid_579459 = query.getOrDefault("fields")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "fields", valid_579459
  var valid_579460 = query.getOrDefault("maxResults")
  valid_579460 = validateParameter(valid_579460, JInt, required = false, default = nil)
  if valid_579460 != nil:
    section.add "maxResults", valid_579460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579461: Call_AdsenseSavedadstylesList_579449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_579461.validator(path, query, header, formData, body)
  let scheme = call_579461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579461.url(scheme.get, call_579461.host, call_579461.base,
                         call_579461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579461, url, valid)

proc call*(call_579462: Call_AdsenseSavedadstylesList_579449; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsenseSavedadstylesList
  ## List all saved ad styles in the user's account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  var query_579463 = newJObject()
  add(query_579463, "key", newJString(key))
  add(query_579463, "prettyPrint", newJBool(prettyPrint))
  add(query_579463, "oauth_token", newJString(oauthToken))
  add(query_579463, "alt", newJString(alt))
  add(query_579463, "userIp", newJString(userIp))
  add(query_579463, "quotaUser", newJString(quotaUser))
  add(query_579463, "pageToken", newJString(pageToken))
  add(query_579463, "fields", newJString(fields))
  add(query_579463, "maxResults", newJInt(maxResults))
  result = call_579462.call(nil, query_579463, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_579449(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_579450, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesList_579451, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_579464 = ref object of OpenApiRestCall_578355
proc url_AdsenseSavedadstylesGet_579466(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseSavedadstylesGet_579465(path: JsonNode; query: JsonNode;
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
  var valid_579467 = path.getOrDefault("savedAdStyleId")
  valid_579467 = validateParameter(valid_579467, JString, required = true,
                                 default = nil)
  if valid_579467 != nil:
    section.add "savedAdStyleId", valid_579467
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579468 = query.getOrDefault("key")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "key", valid_579468
  var valid_579469 = query.getOrDefault("prettyPrint")
  valid_579469 = validateParameter(valid_579469, JBool, required = false,
                                 default = newJBool(true))
  if valid_579469 != nil:
    section.add "prettyPrint", valid_579469
  var valid_579470 = query.getOrDefault("oauth_token")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "oauth_token", valid_579470
  var valid_579471 = query.getOrDefault("alt")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = newJString("json"))
  if valid_579471 != nil:
    section.add "alt", valid_579471
  var valid_579472 = query.getOrDefault("userIp")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "userIp", valid_579472
  var valid_579473 = query.getOrDefault("quotaUser")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "quotaUser", valid_579473
  var valid_579474 = query.getOrDefault("fields")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "fields", valid_579474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579475: Call_AdsenseSavedadstylesGet_579464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_579475.validator(path, query, header, formData, body)
  let scheme = call_579475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579475.url(scheme.get, call_579475.host, call_579475.base,
                         call_579475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579475, url, valid)

proc call*(call_579476: Call_AdsenseSavedadstylesGet_579464;
          savedAdStyleId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseSavedadstylesGet
  ## Get a specific saved ad style from the user's account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  var path_579477 = newJObject()
  var query_579478 = newJObject()
  add(query_579478, "key", newJString(key))
  add(query_579478, "prettyPrint", newJBool(prettyPrint))
  add(query_579478, "oauth_token", newJString(oauthToken))
  add(query_579478, "alt", newJString(alt))
  add(query_579478, "userIp", newJString(userIp))
  add(query_579478, "quotaUser", newJString(quotaUser))
  add(query_579478, "fields", newJString(fields))
  add(path_579477, "savedAdStyleId", newJString(savedAdStyleId))
  result = call_579476.call(path_579477, query_579478, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_579464(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_579465, base: "/adsense/v1.3",
    url: url_AdsenseSavedadstylesGet_579466, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
