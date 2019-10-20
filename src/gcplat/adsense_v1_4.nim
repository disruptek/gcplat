
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
    validator: validate_AdsenseAccountsList_578627, base: "/adsense/v1.4",
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
    validator: validate_AdsenseAccountsGet_578897, base: "/adsense/v1.4",
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdclientsList_578928,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdclientsGetAdCode_578943 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdclientsGetAdCode_578945(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdclientsGetAdCode_578944(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Auto ad code for a given ad client.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to get the code for.
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_578954 = query.getOrDefault("fields")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "fields", valid_578954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578955: Call_AdsenseAccountsAdclientsGetAdCode_578943;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get Auto ad code for a given ad client.
  ## 
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_AdsenseAccountsAdclientsGetAdCode_578943;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAccountsAdclientsGetAdCode
  ## Get Auto ad code for a given ad client.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client to get the code for.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "userIp", newJString(userIp))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(path_578957, "adClientId", newJString(adClientId))
  add(path_578957, "accountId", newJString(accountId))
  add(query_578958, "fields", newJString(fields))
  result = call_578956.call(path_578957, query_578958, nil, nil, nil)

var adsenseAccountsAdclientsGetAdCode* = Call_AdsenseAccountsAdclientsGetAdCode_578943(
    name: "adsenseAccountsAdclientsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adcode",
    validator: validate_AdsenseAccountsAdclientsGetAdCode_578944,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdclientsGetAdCode_578945,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsList_578959 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsList_578961(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsList_578960(path: JsonNode; query: JsonNode;
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
  var valid_578962 = path.getOrDefault("adClientId")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "adClientId", valid_578962
  var valid_578963 = path.getOrDefault("accountId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "accountId", valid_578963
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("userIp")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "userIp", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("pageToken")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "pageToken", valid_578970
  var valid_578971 = query.getOrDefault("includeInactive")
  valid_578971 = validateParameter(valid_578971, JBool, required = false, default = nil)
  if valid_578971 != nil:
    section.add "includeInactive", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  var valid_578973 = query.getOrDefault("maxResults")
  valid_578973 = validateParameter(valid_578973, JInt, required = false, default = nil)
  if valid_578973 != nil:
    section.add "maxResults", valid_578973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578974: Call_AdsenseAccountsAdunitsList_578959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for the specified account.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_AdsenseAccountsAdunitsList_578959; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "userIp", newJString(userIp))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(query_578977, "pageToken", newJString(pageToken))
  add(path_578976, "adClientId", newJString(adClientId))
  add(path_578976, "accountId", newJString(accountId))
  add(query_578977, "includeInactive", newJBool(includeInactive))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "maxResults", newJInt(maxResults))
  result = call_578975.call(path_578976, query_578977, nil, nil, nil)

var adsenseAccountsAdunitsList* = Call_AdsenseAccountsAdunitsList_578959(
    name: "adsenseAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAccountsAdunitsList_578960, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAdunitsList_578961, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGet_578978 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsGet_578980(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGet_578979(path: JsonNode; query: JsonNode;
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
  var valid_578981 = path.getOrDefault("adClientId")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "adClientId", valid_578981
  var valid_578982 = path.getOrDefault("adUnitId")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "adUnitId", valid_578982
  var valid_578983 = path.getOrDefault("accountId")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "accountId", valid_578983
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("userIp")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "userIp", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("fields")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "fields", valid_578990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578991: Call_AdsenseAccountsAdunitsGet_578978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client for the specified account.
  ## 
  let valid = call_578991.validator(path, query, header, formData, body)
  let scheme = call_578991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578991.url(scheme.get, call_578991.host, call_578991.base,
                         call_578991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578991, url, valid)

proc call*(call_578992: Call_AdsenseAccountsAdunitsGet_578978; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578993 = newJObject()
  var query_578994 = newJObject()
  add(query_578994, "key", newJString(key))
  add(query_578994, "prettyPrint", newJBool(prettyPrint))
  add(query_578994, "oauth_token", newJString(oauthToken))
  add(query_578994, "alt", newJString(alt))
  add(query_578994, "userIp", newJString(userIp))
  add(query_578994, "quotaUser", newJString(quotaUser))
  add(path_578993, "adClientId", newJString(adClientId))
  add(path_578993, "adUnitId", newJString(adUnitId))
  add(path_578993, "accountId", newJString(accountId))
  add(query_578994, "fields", newJString(fields))
  result = call_578992.call(path_578993, query_578994, nil, nil, nil)

var adsenseAccountsAdunitsGet* = Call_AdsenseAccountsAdunitsGet_578978(
    name: "adsenseAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAccountsAdunitsGet_578979, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAdunitsGet_578980, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsGetAdCode_578995 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsGetAdCode_578997(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAdunitsGetAdCode_578996(path: JsonNode;
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
  var valid_578998 = path.getOrDefault("adClientId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "adClientId", valid_578998
  var valid_578999 = path.getOrDefault("adUnitId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "adUnitId", valid_578999
  var valid_579000 = path.getOrDefault("accountId")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "accountId", valid_579000
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("userIp")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "userIp", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579008: Call_AdsenseAccountsAdunitsGetAdCode_578995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_AdsenseAccountsAdunitsGetAdCode_578995;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "userIp", newJString(userIp))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(path_579010, "adClientId", newJString(adClientId))
  add(path_579010, "adUnitId", newJString(adUnitId))
  add(path_579010, "accountId", newJString(accountId))
  add(query_579011, "fields", newJString(fields))
  result = call_579009.call(path_579010, query_579011, nil, nil, nil)

var adsenseAccountsAdunitsGetAdCode* = Call_AdsenseAccountsAdunitsGetAdCode_578995(
    name: "adsenseAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAccountsAdunitsGetAdCode_578996,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdunitsGetAdCode_578997,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAdunitsCustomchannelsList_579012 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAdunitsCustomchannelsList_579014(protocol: Scheme;
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

proc validate_AdsenseAccountsAdunitsCustomchannelsList_579013(path: JsonNode;
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
  var valid_579015 = path.getOrDefault("adClientId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "adClientId", valid_579015
  var valid_579016 = path.getOrDefault("adUnitId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "adUnitId", valid_579016
  var valid_579017 = path.getOrDefault("accountId")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "accountId", valid_579017
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("alt")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("json"))
  if valid_579021 != nil:
    section.add "alt", valid_579021
  var valid_579022 = query.getOrDefault("userIp")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "userIp", valid_579022
  var valid_579023 = query.getOrDefault("quotaUser")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "quotaUser", valid_579023
  var valid_579024 = query.getOrDefault("pageToken")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "pageToken", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  var valid_579026 = query.getOrDefault("maxResults")
  valid_579026 = validateParameter(valid_579026, JInt, required = false, default = nil)
  if valid_579026 != nil:
    section.add "maxResults", valid_579026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579027: Call_AdsenseAccountsAdunitsCustomchannelsList_579012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_579027.validator(path, query, header, formData, body)
  let scheme = call_579027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579027.url(scheme.get, call_579027.host, call_579027.base,
                         call_579027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579027, url, valid)

proc call*(call_579028: Call_AdsenseAccountsAdunitsCustomchannelsList_579012;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579029 = newJObject()
  var query_579030 = newJObject()
  add(query_579030, "key", newJString(key))
  add(query_579030, "prettyPrint", newJBool(prettyPrint))
  add(query_579030, "oauth_token", newJString(oauthToken))
  add(query_579030, "alt", newJString(alt))
  add(query_579030, "userIp", newJString(userIp))
  add(query_579030, "quotaUser", newJString(quotaUser))
  add(query_579030, "pageToken", newJString(pageToken))
  add(path_579029, "adClientId", newJString(adClientId))
  add(path_579029, "adUnitId", newJString(adUnitId))
  add(path_579029, "accountId", newJString(accountId))
  add(query_579030, "fields", newJString(fields))
  add(query_579030, "maxResults", newJInt(maxResults))
  result = call_579028.call(path_579029, query_579030, nil, nil, nil)

var adsenseAccountsAdunitsCustomchannelsList* = Call_AdsenseAccountsAdunitsCustomchannelsList_579012(
    name: "adsenseAccountsAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAccountsAdunitsCustomchannelsList_579013,
    base: "/adsense/v1.4", url: url_AdsenseAccountsAdunitsCustomchannelsList_579014,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsList_579031 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsCustomchannelsList_579033(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsList_579032(path: JsonNode;
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
  var valid_579034 = path.getOrDefault("adClientId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "adClientId", valid_579034
  var valid_579035 = path.getOrDefault("accountId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "accountId", valid_579035
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("alt")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("json"))
  if valid_579039 != nil:
    section.add "alt", valid_579039
  var valid_579040 = query.getOrDefault("userIp")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "userIp", valid_579040
  var valid_579041 = query.getOrDefault("quotaUser")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "quotaUser", valid_579041
  var valid_579042 = query.getOrDefault("pageToken")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "pageToken", valid_579042
  var valid_579043 = query.getOrDefault("fields")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "fields", valid_579043
  var valid_579044 = query.getOrDefault("maxResults")
  valid_579044 = validateParameter(valid_579044, JInt, required = false, default = nil)
  if valid_579044 != nil:
    section.add "maxResults", valid_579044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579045: Call_AdsenseAccountsCustomchannelsList_579031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for the specified account.
  ## 
  let valid = call_579045.validator(path, query, header, formData, body)
  let scheme = call_579045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579045.url(scheme.get, call_579045.host, call_579045.base,
                         call_579045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579045, url, valid)

proc call*(call_579046: Call_AdsenseAccountsCustomchannelsList_579031;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579047 = newJObject()
  var query_579048 = newJObject()
  add(query_579048, "key", newJString(key))
  add(query_579048, "prettyPrint", newJBool(prettyPrint))
  add(query_579048, "oauth_token", newJString(oauthToken))
  add(query_579048, "alt", newJString(alt))
  add(query_579048, "userIp", newJString(userIp))
  add(query_579048, "quotaUser", newJString(quotaUser))
  add(query_579048, "pageToken", newJString(pageToken))
  add(path_579047, "adClientId", newJString(adClientId))
  add(path_579047, "accountId", newJString(accountId))
  add(query_579048, "fields", newJString(fields))
  add(query_579048, "maxResults", newJInt(maxResults))
  result = call_579046.call(path_579047, query_579048, nil, nil, nil)

var adsenseAccountsCustomchannelsList* = Call_AdsenseAccountsCustomchannelsList_579031(
    name: "adsenseAccountsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseAccountsCustomchannelsList_579032,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsList_579033,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsGet_579049 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsCustomchannelsGet_579051(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsCustomchannelsGet_579050(path: JsonNode;
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
  var valid_579052 = path.getOrDefault("adClientId")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "adClientId", valid_579052
  var valid_579053 = path.getOrDefault("accountId")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "accountId", valid_579053
  var valid_579054 = path.getOrDefault("customChannelId")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "customChannelId", valid_579054
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579055 = query.getOrDefault("key")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "key", valid_579055
  var valid_579056 = query.getOrDefault("prettyPrint")
  valid_579056 = validateParameter(valid_579056, JBool, required = false,
                                 default = newJBool(true))
  if valid_579056 != nil:
    section.add "prettyPrint", valid_579056
  var valid_579057 = query.getOrDefault("oauth_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "oauth_token", valid_579057
  var valid_579058 = query.getOrDefault("alt")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("json"))
  if valid_579058 != nil:
    section.add "alt", valid_579058
  var valid_579059 = query.getOrDefault("userIp")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "userIp", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("fields")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "fields", valid_579061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579062: Call_AdsenseAccountsCustomchannelsGet_579049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client for the specified account.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_AdsenseAccountsCustomchannelsGet_579049;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   accountId: string (required)
  ##            : Account to which the ad client belongs.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "userIp", newJString(userIp))
  add(query_579065, "quotaUser", newJString(quotaUser))
  add(path_579064, "adClientId", newJString(adClientId))
  add(path_579064, "accountId", newJString(accountId))
  add(path_579064, "customChannelId", newJString(customChannelId))
  add(query_579065, "fields", newJString(fields))
  result = call_579063.call(path_579064, query_579065, nil, nil, nil)

var adsenseAccountsCustomchannelsGet* = Call_AdsenseAccountsCustomchannelsGet_579049(
    name: "adsenseAccountsCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseAccountsCustomchannelsGet_579050,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsGet_579051,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsCustomchannelsAdunitsList_579066 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsCustomchannelsAdunitsList_579068(protocol: Scheme;
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

proc validate_AdsenseAccountsCustomchannelsAdunitsList_579067(path: JsonNode;
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
  var valid_579069 = path.getOrDefault("adClientId")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "adClientId", valid_579069
  var valid_579070 = path.getOrDefault("accountId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "accountId", valid_579070
  var valid_579071 = path.getOrDefault("customChannelId")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "customChannelId", valid_579071
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_579072 = query.getOrDefault("key")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "key", valid_579072
  var valid_579073 = query.getOrDefault("prettyPrint")
  valid_579073 = validateParameter(valid_579073, JBool, required = false,
                                 default = newJBool(true))
  if valid_579073 != nil:
    section.add "prettyPrint", valid_579073
  var valid_579074 = query.getOrDefault("oauth_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "oauth_token", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("userIp")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "userIp", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("pageToken")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "pageToken", valid_579078
  var valid_579079 = query.getOrDefault("includeInactive")
  valid_579079 = validateParameter(valid_579079, JBool, required = false, default = nil)
  if valid_579079 != nil:
    section.add "includeInactive", valid_579079
  var valid_579080 = query.getOrDefault("fields")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "fields", valid_579080
  var valid_579081 = query.getOrDefault("maxResults")
  valid_579081 = validateParameter(valid_579081, JInt, required = false, default = nil)
  if valid_579081 != nil:
    section.add "maxResults", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_AdsenseAccountsCustomchannelsAdunitsList_579066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_AdsenseAccountsCustomchannelsAdunitsList_579066;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "userIp", newJString(userIp))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(query_579085, "pageToken", newJString(pageToken))
  add(path_579084, "adClientId", newJString(adClientId))
  add(path_579084, "accountId", newJString(accountId))
  add(path_579084, "customChannelId", newJString(customChannelId))
  add(query_579085, "includeInactive", newJBool(includeInactive))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "maxResults", newJInt(maxResults))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var adsenseAccountsCustomchannelsAdunitsList* = Call_AdsenseAccountsCustomchannelsAdunitsList_579066(
    name: "adsenseAccountsCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseAccountsCustomchannelsAdunitsList_579067,
    base: "/adsense/v1.4", url: url_AdsenseAccountsCustomchannelsAdunitsList_579068,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsUrlchannelsList_579086 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsUrlchannelsList_579088(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsUrlchannelsList_579087(path: JsonNode;
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
  var valid_579089 = path.getOrDefault("adClientId")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "adClientId", valid_579089
  var valid_579090 = path.getOrDefault("accountId")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "accountId", valid_579090
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  section = newJObject()
  var valid_579091 = query.getOrDefault("key")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "key", valid_579091
  var valid_579092 = query.getOrDefault("prettyPrint")
  valid_579092 = validateParameter(valid_579092, JBool, required = false,
                                 default = newJBool(true))
  if valid_579092 != nil:
    section.add "prettyPrint", valid_579092
  var valid_579093 = query.getOrDefault("oauth_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "oauth_token", valid_579093
  var valid_579094 = query.getOrDefault("alt")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("json"))
  if valid_579094 != nil:
    section.add "alt", valid_579094
  var valid_579095 = query.getOrDefault("userIp")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "userIp", valid_579095
  var valid_579096 = query.getOrDefault("quotaUser")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "quotaUser", valid_579096
  var valid_579097 = query.getOrDefault("pageToken")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "pageToken", valid_579097
  var valid_579098 = query.getOrDefault("fields")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "fields", valid_579098
  var valid_579099 = query.getOrDefault("maxResults")
  valid_579099 = validateParameter(valid_579099, JInt, required = false, default = nil)
  if valid_579099 != nil:
    section.add "maxResults", valid_579099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579100: Call_AdsenseAccountsUrlchannelsList_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for the specified account.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_AdsenseAccountsUrlchannelsList_579086;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "userIp", newJString(userIp))
  add(query_579103, "quotaUser", newJString(quotaUser))
  add(query_579103, "pageToken", newJString(pageToken))
  add(path_579102, "adClientId", newJString(adClientId))
  add(path_579102, "accountId", newJString(accountId))
  add(query_579103, "fields", newJString(fields))
  add(query_579103, "maxResults", newJInt(maxResults))
  result = call_579101.call(path_579102, query_579103, nil, nil, nil)

var adsenseAccountsUrlchannelsList* = Call_AdsenseAccountsUrlchannelsList_579086(
    name: "adsenseAccountsUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseAccountsUrlchannelsList_579087,
    base: "/adsense/v1.4", url: url_AdsenseAccountsUrlchannelsList_579088,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsList_579104 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAlertsList_579106(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAlertsList_579105(path: JsonNode; query: JsonNode;
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
  ##         : The locale to use for translating alert messages. The account locale will be used if this is not supplied. The AdSense default (English) will be used if the supplied locale is invalid or unsupported.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  var valid_579112 = query.getOrDefault("alt")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("json"))
  if valid_579112 != nil:
    section.add "alt", valid_579112
  var valid_579113 = query.getOrDefault("userIp")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "userIp", valid_579113
  var valid_579114 = query.getOrDefault("quotaUser")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "quotaUser", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579116: Call_AdsenseAccountsAlertsList_579104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for the specified AdSense account.
  ## 
  let valid = call_579116.validator(path, query, header, formData, body)
  let scheme = call_579116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579116.url(scheme.get, call_579116.host, call_579116.base,
                         call_579116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579116, url, valid)

proc call*(call_579117: Call_AdsenseAccountsAlertsList_579104; accountId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account for which to retrieve the alerts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579118 = newJObject()
  var query_579119 = newJObject()
  add(query_579119, "key", newJString(key))
  add(query_579119, "prettyPrint", newJBool(prettyPrint))
  add(query_579119, "oauth_token", newJString(oauthToken))
  add(query_579119, "locale", newJString(locale))
  add(query_579119, "alt", newJString(alt))
  add(query_579119, "userIp", newJString(userIp))
  add(query_579119, "quotaUser", newJString(quotaUser))
  add(path_579118, "accountId", newJString(accountId))
  add(query_579119, "fields", newJString(fields))
  result = call_579117.call(path_579118, query_579119, nil, nil, nil)

var adsenseAccountsAlertsList* = Call_AdsenseAccountsAlertsList_579104(
    name: "adsenseAccountsAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts",
    validator: validate_AdsenseAccountsAlertsList_579105, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAlertsList_579106, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsAlertsDelete_579120 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsAlertsDelete_579122(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsAlertsDelete_579121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alertId: JString (required)
  ##          : Alert to delete.
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alertId` field"
  var valid_579123 = path.getOrDefault("alertId")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "alertId", valid_579123
  var valid_579124 = path.getOrDefault("accountId")
  valid_579124 = validateParameter(valid_579124, JString, required = true,
                                 default = nil)
  if valid_579124 != nil:
    section.add "accountId", valid_579124
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579125 = query.getOrDefault("key")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "key", valid_579125
  var valid_579126 = query.getOrDefault("prettyPrint")
  valid_579126 = validateParameter(valid_579126, JBool, required = false,
                                 default = newJBool(true))
  if valid_579126 != nil:
    section.add "prettyPrint", valid_579126
  var valid_579127 = query.getOrDefault("oauth_token")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "oauth_token", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("userIp")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "userIp", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("fields")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "fields", valid_579131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579132: Call_AdsenseAccountsAlertsDelete_579120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ## 
  let valid = call_579132.validator(path, query, header, formData, body)
  let scheme = call_579132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579132.url(scheme.get, call_579132.host, call_579132.base,
                         call_579132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579132, url, valid)

proc call*(call_579133: Call_AdsenseAccountsAlertsDelete_579120; alertId: string;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsenseAccountsAlertsDelete
  ## Dismiss (delete) the specified alert from the specified publisher AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Alert to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579134 = newJObject()
  var query_579135 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(path_579134, "alertId", newJString(alertId))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "userIp", newJString(userIp))
  add(query_579135, "quotaUser", newJString(quotaUser))
  add(path_579134, "accountId", newJString(accountId))
  add(query_579135, "fields", newJString(fields))
  result = call_579133.call(path_579134, query_579135, nil, nil, nil)

var adsenseAccountsAlertsDelete* = Call_AdsenseAccountsAlertsDelete_579120(
    name: "adsenseAccountsAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/accounts/{accountId}/alerts/{alertId}",
    validator: validate_AdsenseAccountsAlertsDelete_579121, base: "/adsense/v1.4",
    url: url_AdsenseAccountsAlertsDelete_579122, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsPaymentsList_579136 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsPaymentsList_579138(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsPaymentsList_579137(path: JsonNode; query: JsonNode;
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
  var valid_579139 = path.getOrDefault("accountId")
  valid_579139 = validateParameter(valid_579139, JString, required = true,
                                 default = nil)
  if valid_579139 != nil:
    section.add "accountId", valid_579139
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579140 = query.getOrDefault("key")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "key", valid_579140
  var valid_579141 = query.getOrDefault("prettyPrint")
  valid_579141 = validateParameter(valid_579141, JBool, required = false,
                                 default = newJBool(true))
  if valid_579141 != nil:
    section.add "prettyPrint", valid_579141
  var valid_579142 = query.getOrDefault("oauth_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "oauth_token", valid_579142
  var valid_579143 = query.getOrDefault("alt")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("json"))
  if valid_579143 != nil:
    section.add "alt", valid_579143
  var valid_579144 = query.getOrDefault("userIp")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "userIp", valid_579144
  var valid_579145 = query.getOrDefault("quotaUser")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "quotaUser", valid_579145
  var valid_579146 = query.getOrDefault("fields")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "fields", valid_579146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579147: Call_AdsenseAccountsPaymentsList_579136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the payments for the specified AdSense account.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_AdsenseAccountsPaymentsList_579136; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsenseAccountsPaymentsList
  ## List the payments for the specified AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account for which to retrieve the payments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579149 = newJObject()
  var query_579150 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "userIp", newJString(userIp))
  add(query_579150, "quotaUser", newJString(quotaUser))
  add(path_579149, "accountId", newJString(accountId))
  add(query_579150, "fields", newJString(fields))
  result = call_579148.call(path_579149, query_579150, nil, nil, nil)

var adsenseAccountsPaymentsList* = Call_AdsenseAccountsPaymentsList_579136(
    name: "adsenseAccountsPaymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/payments",
    validator: validate_AdsenseAccountsPaymentsList_579137, base: "/adsense/v1.4",
    url: url_AdsenseAccountsPaymentsList_579138, schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsGenerate_579151 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsReportsGenerate_579153(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsGenerate_579152(path: JsonNode;
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
  var valid_579154 = path.getOrDefault("accountId")
  valid_579154 = validateParameter(valid_579154, JString, required = true,
                                 default = nil)
  if valid_579154 != nil:
    section.add "accountId", valid_579154
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var valid_579155 = query.getOrDefault("key")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "key", valid_579155
  var valid_579156 = query.getOrDefault("prettyPrint")
  valid_579156 = validateParameter(valid_579156, JBool, required = false,
                                 default = newJBool(true))
  if valid_579156 != nil:
    section.add "prettyPrint", valid_579156
  var valid_579157 = query.getOrDefault("oauth_token")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "oauth_token", valid_579157
  var valid_579158 = query.getOrDefault("locale")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "locale", valid_579158
  var valid_579159 = query.getOrDefault("currency")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "currency", valid_579159
  var valid_579160 = query.getOrDefault("alt")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("json"))
  if valid_579160 != nil:
    section.add "alt", valid_579160
  var valid_579161 = query.getOrDefault("userIp")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "userIp", valid_579161
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579162 = query.getOrDefault("endDate")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "endDate", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("startIndex")
  valid_579164 = validateParameter(valid_579164, JInt, required = false, default = nil)
  if valid_579164 != nil:
    section.add "startIndex", valid_579164
  var valid_579165 = query.getOrDefault("filter")
  valid_579165 = validateParameter(valid_579165, JArray, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "filter", valid_579165
  var valid_579166 = query.getOrDefault("useTimezoneReporting")
  valid_579166 = validateParameter(valid_579166, JBool, required = false, default = nil)
  if valid_579166 != nil:
    section.add "useTimezoneReporting", valid_579166
  var valid_579167 = query.getOrDefault("dimension")
  valid_579167 = validateParameter(valid_579167, JArray, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "dimension", valid_579167
  var valid_579168 = query.getOrDefault("metric")
  valid_579168 = validateParameter(valid_579168, JArray, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "metric", valid_579168
  var valid_579169 = query.getOrDefault("fields")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "fields", valid_579169
  var valid_579170 = query.getOrDefault("startDate")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "startDate", valid_579170
  var valid_579171 = query.getOrDefault("maxResults")
  valid_579171 = validateParameter(valid_579171, JInt, required = false, default = nil)
  if valid_579171 != nil:
    section.add "maxResults", valid_579171
  var valid_579172 = query.getOrDefault("sort")
  valid_579172 = validateParameter(valid_579172, JArray, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "sort", valid_579172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579173: Call_AdsenseAccountsReportsGenerate_579151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579173.validator(path, query, header, formData, body)
  let scheme = call_579173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579173.url(scheme.get, call_579173.host, call_579173.base,
                         call_579173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579173, url, valid)

proc call*(call_579174: Call_AdsenseAccountsReportsGenerate_579151;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579175 = newJObject()
  var query_579176 = newJObject()
  add(query_579176, "key", newJString(key))
  add(query_579176, "prettyPrint", newJBool(prettyPrint))
  add(query_579176, "oauth_token", newJString(oauthToken))
  add(query_579176, "locale", newJString(locale))
  add(query_579176, "currency", newJString(currency))
  add(query_579176, "alt", newJString(alt))
  add(query_579176, "userIp", newJString(userIp))
  add(query_579176, "endDate", newJString(endDate))
  add(query_579176, "quotaUser", newJString(quotaUser))
  add(query_579176, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579176.add "filter", filter
  add(query_579176, "useTimezoneReporting", newJBool(useTimezoneReporting))
  if dimension != nil:
    query_579176.add "dimension", dimension
  add(path_579175, "accountId", newJString(accountId))
  if metric != nil:
    query_579176.add "metric", metric
  add(query_579176, "fields", newJString(fields))
  add(query_579176, "startDate", newJString(startDate))
  add(query_579176, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579176.add "sort", sort
  result = call_579174.call(path_579175, query_579176, nil, nil, nil)

var adsenseAccountsReportsGenerate* = Call_AdsenseAccountsReportsGenerate_579151(
    name: "adsenseAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsenseAccountsReportsGenerate_579152,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsGenerate_579153,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedList_579177 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsReportsSavedList_579179(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedList_579178(path: JsonNode;
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
  var valid_579180 = path.getOrDefault("accountId")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "accountId", valid_579180
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  section = newJObject()
  var valid_579181 = query.getOrDefault("key")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "key", valid_579181
  var valid_579182 = query.getOrDefault("prettyPrint")
  valid_579182 = validateParameter(valid_579182, JBool, required = false,
                                 default = newJBool(true))
  if valid_579182 != nil:
    section.add "prettyPrint", valid_579182
  var valid_579183 = query.getOrDefault("oauth_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "oauth_token", valid_579183
  var valid_579184 = query.getOrDefault("alt")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("json"))
  if valid_579184 != nil:
    section.add "alt", valid_579184
  var valid_579185 = query.getOrDefault("userIp")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "userIp", valid_579185
  var valid_579186 = query.getOrDefault("quotaUser")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "quotaUser", valid_579186
  var valid_579187 = query.getOrDefault("pageToken")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "pageToken", valid_579187
  var valid_579188 = query.getOrDefault("fields")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "fields", valid_579188
  var valid_579189 = query.getOrDefault("maxResults")
  valid_579189 = validateParameter(valid_579189, JInt, required = false, default = nil)
  if valid_579189 != nil:
    section.add "maxResults", valid_579189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579190: Call_AdsenseAccountsReportsSavedList_579177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in the specified AdSense account.
  ## 
  let valid = call_579190.validator(path, query, header, formData, body)
  let scheme = call_579190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579190.url(scheme.get, call_579190.host, call_579190.base,
                         call_579190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579190, url, valid)

proc call*(call_579191: Call_AdsenseAccountsReportsSavedList_579177;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  var path_579192 = newJObject()
  var query_579193 = newJObject()
  add(query_579193, "key", newJString(key))
  add(query_579193, "prettyPrint", newJBool(prettyPrint))
  add(query_579193, "oauth_token", newJString(oauthToken))
  add(query_579193, "alt", newJString(alt))
  add(query_579193, "userIp", newJString(userIp))
  add(query_579193, "quotaUser", newJString(quotaUser))
  add(query_579193, "pageToken", newJString(pageToken))
  add(path_579192, "accountId", newJString(accountId))
  add(query_579193, "fields", newJString(fields))
  add(query_579193, "maxResults", newJInt(maxResults))
  result = call_579191.call(path_579192, query_579193, nil, nil, nil)

var adsenseAccountsReportsSavedList* = Call_AdsenseAccountsReportsSavedList_579177(
    name: "adsenseAccountsReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports/saved",
    validator: validate_AdsenseAccountsReportsSavedList_579178,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsSavedList_579179,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsReportsSavedGenerate_579194 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsReportsSavedGenerate_579196(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsReportsSavedGenerate_579195(path: JsonNode;
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
  var valid_579197 = path.getOrDefault("savedReportId")
  valid_579197 = validateParameter(valid_579197, JString, required = true,
                                 default = nil)
  if valid_579197 != nil:
    section.add "savedReportId", valid_579197
  var valid_579198 = path.getOrDefault("accountId")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "accountId", valid_579198
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  section = newJObject()
  var valid_579199 = query.getOrDefault("key")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "key", valid_579199
  var valid_579200 = query.getOrDefault("prettyPrint")
  valid_579200 = validateParameter(valid_579200, JBool, required = false,
                                 default = newJBool(true))
  if valid_579200 != nil:
    section.add "prettyPrint", valid_579200
  var valid_579201 = query.getOrDefault("oauth_token")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "oauth_token", valid_579201
  var valid_579202 = query.getOrDefault("locale")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "locale", valid_579202
  var valid_579203 = query.getOrDefault("alt")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("json"))
  if valid_579203 != nil:
    section.add "alt", valid_579203
  var valid_579204 = query.getOrDefault("userIp")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "userIp", valid_579204
  var valid_579205 = query.getOrDefault("quotaUser")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "quotaUser", valid_579205
  var valid_579206 = query.getOrDefault("startIndex")
  valid_579206 = validateParameter(valid_579206, JInt, required = false, default = nil)
  if valid_579206 != nil:
    section.add "startIndex", valid_579206
  var valid_579207 = query.getOrDefault("fields")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "fields", valid_579207
  var valid_579208 = query.getOrDefault("maxResults")
  valid_579208 = validateParameter(valid_579208, JInt, required = false, default = nil)
  if valid_579208 != nil:
    section.add "maxResults", valid_579208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579209: Call_AdsenseAccountsReportsSavedGenerate_579194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579209.validator(path, query, header, formData, body)
  let scheme = call_579209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579209.url(scheme.get, call_579209.host, call_579209.base,
                         call_579209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579209, url, valid)

proc call*(call_579210: Call_AdsenseAccountsReportsSavedGenerate_579194;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   accountId: string (required)
  ##            : Account to which the saved reports belong.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  var path_579211 = newJObject()
  var query_579212 = newJObject()
  add(query_579212, "key", newJString(key))
  add(query_579212, "prettyPrint", newJBool(prettyPrint))
  add(query_579212, "oauth_token", newJString(oauthToken))
  add(query_579212, "locale", newJString(locale))
  add(query_579212, "alt", newJString(alt))
  add(query_579212, "userIp", newJString(userIp))
  add(path_579211, "savedReportId", newJString(savedReportId))
  add(query_579212, "quotaUser", newJString(quotaUser))
  add(query_579212, "startIndex", newJInt(startIndex))
  add(path_579211, "accountId", newJString(accountId))
  add(query_579212, "fields", newJString(fields))
  add(query_579212, "maxResults", newJInt(maxResults))
  result = call_579210.call(path_579211, query_579212, nil, nil, nil)

var adsenseAccountsReportsSavedGenerate* = Call_AdsenseAccountsReportsSavedGenerate_579194(
    name: "adsenseAccountsReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/reports/{savedReportId}",
    validator: validate_AdsenseAccountsReportsSavedGenerate_579195,
    base: "/adsense/v1.4", url: url_AdsenseAccountsReportsSavedGenerate_579196,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesList_579213 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsSavedadstylesList_579215(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesList_579214(path: JsonNode;
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
  var valid_579216 = path.getOrDefault("accountId")
  valid_579216 = validateParameter(valid_579216, JString, required = true,
                                 default = nil)
  if valid_579216 != nil:
    section.add "accountId", valid_579216
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  section = newJObject()
  var valid_579217 = query.getOrDefault("key")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "key", valid_579217
  var valid_579218 = query.getOrDefault("prettyPrint")
  valid_579218 = validateParameter(valid_579218, JBool, required = false,
                                 default = newJBool(true))
  if valid_579218 != nil:
    section.add "prettyPrint", valid_579218
  var valid_579219 = query.getOrDefault("oauth_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "oauth_token", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("userIp")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "userIp", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("pageToken")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "pageToken", valid_579223
  var valid_579224 = query.getOrDefault("fields")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "fields", valid_579224
  var valid_579225 = query.getOrDefault("maxResults")
  valid_579225 = validateParameter(valid_579225, JInt, required = false, default = nil)
  if valid_579225 != nil:
    section.add "maxResults", valid_579225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579226: Call_AdsenseAccountsSavedadstylesList_579213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved ad styles in the specified account.
  ## 
  let valid = call_579226.validator(path, query, header, formData, body)
  let scheme = call_579226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579226.url(scheme.get, call_579226.host, call_579226.base,
                         call_579226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579226, url, valid)

proc call*(call_579227: Call_AdsenseAccountsSavedadstylesList_579213;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   accountId: string (required)
  ##            : Account for which to list saved ad styles.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  var path_579228 = newJObject()
  var query_579229 = newJObject()
  add(query_579229, "key", newJString(key))
  add(query_579229, "prettyPrint", newJBool(prettyPrint))
  add(query_579229, "oauth_token", newJString(oauthToken))
  add(query_579229, "alt", newJString(alt))
  add(query_579229, "userIp", newJString(userIp))
  add(query_579229, "quotaUser", newJString(quotaUser))
  add(query_579229, "pageToken", newJString(pageToken))
  add(path_579228, "accountId", newJString(accountId))
  add(query_579229, "fields", newJString(fields))
  add(query_579229, "maxResults", newJInt(maxResults))
  result = call_579227.call(path_579228, query_579229, nil, nil, nil)

var adsenseAccountsSavedadstylesList* = Call_AdsenseAccountsSavedadstylesList_579213(
    name: "adsenseAccountsSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/savedadstyles",
    validator: validate_AdsenseAccountsSavedadstylesList_579214,
    base: "/adsense/v1.4", url: url_AdsenseAccountsSavedadstylesList_579215,
    schemes: {Scheme.Https})
type
  Call_AdsenseAccountsSavedadstylesGet_579230 = ref object of OpenApiRestCall_578355
proc url_AdsenseAccountsSavedadstylesGet_579232(protocol: Scheme; host: string;
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

proc validate_AdsenseAccountsSavedadstylesGet_579231(path: JsonNode;
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
  var valid_579233 = path.getOrDefault("accountId")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "accountId", valid_579233
  var valid_579234 = path.getOrDefault("savedAdStyleId")
  valid_579234 = validateParameter(valid_579234, JString, required = true,
                                 default = nil)
  if valid_579234 != nil:
    section.add "savedAdStyleId", valid_579234
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579235 = query.getOrDefault("key")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "key", valid_579235
  var valid_579236 = query.getOrDefault("prettyPrint")
  valid_579236 = validateParameter(valid_579236, JBool, required = false,
                                 default = newJBool(true))
  if valid_579236 != nil:
    section.add "prettyPrint", valid_579236
  var valid_579237 = query.getOrDefault("oauth_token")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "oauth_token", valid_579237
  var valid_579238 = query.getOrDefault("alt")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = newJString("json"))
  if valid_579238 != nil:
    section.add "alt", valid_579238
  var valid_579239 = query.getOrDefault("userIp")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "userIp", valid_579239
  var valid_579240 = query.getOrDefault("quotaUser")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "quotaUser", valid_579240
  var valid_579241 = query.getOrDefault("fields")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "fields", valid_579241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579242: Call_AdsenseAccountsSavedadstylesGet_579230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List a specific saved ad style for the specified account.
  ## 
  let valid = call_579242.validator(path, query, header, formData, body)
  let scheme = call_579242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579242.url(scheme.get, call_579242.host, call_579242.base,
                         call_579242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579242, url, valid)

proc call*(call_579243: Call_AdsenseAccountsSavedadstylesGet_579230;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   accountId: string (required)
  ##            : Account for which to get the saved ad style.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  var path_579244 = newJObject()
  var query_579245 = newJObject()
  add(query_579245, "key", newJString(key))
  add(query_579245, "prettyPrint", newJBool(prettyPrint))
  add(query_579245, "oauth_token", newJString(oauthToken))
  add(query_579245, "alt", newJString(alt))
  add(query_579245, "userIp", newJString(userIp))
  add(query_579245, "quotaUser", newJString(quotaUser))
  add(path_579244, "accountId", newJString(accountId))
  add(query_579245, "fields", newJString(fields))
  add(path_579244, "savedAdStyleId", newJString(savedAdStyleId))
  result = call_579243.call(path_579244, query_579245, nil, nil, nil)

var adsenseAccountsSavedadstylesGet* = Call_AdsenseAccountsSavedadstylesGet_579230(
    name: "adsenseAccountsSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseAccountsSavedadstylesGet_579231,
    base: "/adsense/v1.4", url: url_AdsenseAccountsSavedadstylesGet_579232,
    schemes: {Scheme.Https})
type
  Call_AdsenseAdclientsList_579246 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdclientsList_579248(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAdclientsList_579247(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad clients to include in the response, used for paging.
  section = newJObject()
  var valid_579249 = query.getOrDefault("key")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "key", valid_579249
  var valid_579250 = query.getOrDefault("prettyPrint")
  valid_579250 = validateParameter(valid_579250, JBool, required = false,
                                 default = newJBool(true))
  if valid_579250 != nil:
    section.add "prettyPrint", valid_579250
  var valid_579251 = query.getOrDefault("oauth_token")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "oauth_token", valid_579251
  var valid_579252 = query.getOrDefault("alt")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = newJString("json"))
  if valid_579252 != nil:
    section.add "alt", valid_579252
  var valid_579253 = query.getOrDefault("userIp")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "userIp", valid_579253
  var valid_579254 = query.getOrDefault("quotaUser")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "quotaUser", valid_579254
  var valid_579255 = query.getOrDefault("pageToken")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "pageToken", valid_579255
  var valid_579256 = query.getOrDefault("fields")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fields", valid_579256
  var valid_579257 = query.getOrDefault("maxResults")
  valid_579257 = validateParameter(valid_579257, JInt, required = false, default = nil)
  if valid_579257 != nil:
    section.add "maxResults", valid_579257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579258: Call_AdsenseAdclientsList_579246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this AdSense account.
  ## 
  let valid = call_579258.validator(path, query, header, formData, body)
  let scheme = call_579258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579258.url(scheme.get, call_579258.host, call_579258.base,
                         call_579258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579258, url, valid)

proc call*(call_579259: Call_AdsenseAdclientsList_579246; key: string = "";
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through ad clients. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad clients to include in the response, used for paging.
  var query_579260 = newJObject()
  add(query_579260, "key", newJString(key))
  add(query_579260, "prettyPrint", newJBool(prettyPrint))
  add(query_579260, "oauth_token", newJString(oauthToken))
  add(query_579260, "alt", newJString(alt))
  add(query_579260, "userIp", newJString(userIp))
  add(query_579260, "quotaUser", newJString(quotaUser))
  add(query_579260, "pageToken", newJString(pageToken))
  add(query_579260, "fields", newJString(fields))
  add(query_579260, "maxResults", newJInt(maxResults))
  result = call_579259.call(nil, query_579260, nil, nil, nil)

var adsenseAdclientsList* = Call_AdsenseAdclientsList_579246(
    name: "adsenseAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsenseAdclientsList_579247, base: "/adsense/v1.4",
    url: url_AdsenseAdclientsList_579248, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsList_579261 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsList_579263(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsList_579262(path: JsonNode; query: JsonNode;
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
  var valid_579264 = path.getOrDefault("adClientId")
  valid_579264 = validateParameter(valid_579264, JString, required = true,
                                 default = nil)
  if valid_579264 != nil:
    section.add "adClientId", valid_579264
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_579265 = query.getOrDefault("key")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "key", valid_579265
  var valid_579266 = query.getOrDefault("prettyPrint")
  valid_579266 = validateParameter(valid_579266, JBool, required = false,
                                 default = newJBool(true))
  if valid_579266 != nil:
    section.add "prettyPrint", valid_579266
  var valid_579267 = query.getOrDefault("oauth_token")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "oauth_token", valid_579267
  var valid_579268 = query.getOrDefault("alt")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = newJString("json"))
  if valid_579268 != nil:
    section.add "alt", valid_579268
  var valid_579269 = query.getOrDefault("userIp")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "userIp", valid_579269
  var valid_579270 = query.getOrDefault("quotaUser")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "quotaUser", valid_579270
  var valid_579271 = query.getOrDefault("pageToken")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "pageToken", valid_579271
  var valid_579272 = query.getOrDefault("includeInactive")
  valid_579272 = validateParameter(valid_579272, JBool, required = false, default = nil)
  if valid_579272 != nil:
    section.add "includeInactive", valid_579272
  var valid_579273 = query.getOrDefault("fields")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "fields", valid_579273
  var valid_579274 = query.getOrDefault("maxResults")
  valid_579274 = validateParameter(valid_579274, JInt, required = false, default = nil)
  if valid_579274 != nil:
    section.add "maxResults", valid_579274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579275: Call_AdsenseAdunitsList_579261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this AdSense account.
  ## 
  let valid = call_579275.validator(path, query, header, formData, body)
  let scheme = call_579275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579275.url(scheme.get, call_579275.host, call_579275.base,
                         call_579275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579275, url, valid)

proc call*(call_579276: Call_AdsenseAdunitsList_579261; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579277 = newJObject()
  var query_579278 = newJObject()
  add(query_579278, "key", newJString(key))
  add(query_579278, "prettyPrint", newJBool(prettyPrint))
  add(query_579278, "oauth_token", newJString(oauthToken))
  add(query_579278, "alt", newJString(alt))
  add(query_579278, "userIp", newJString(userIp))
  add(query_579278, "quotaUser", newJString(quotaUser))
  add(query_579278, "pageToken", newJString(pageToken))
  add(path_579277, "adClientId", newJString(adClientId))
  add(query_579278, "includeInactive", newJBool(includeInactive))
  add(query_579278, "fields", newJString(fields))
  add(query_579278, "maxResults", newJInt(maxResults))
  result = call_579276.call(path_579277, query_579278, nil, nil, nil)

var adsenseAdunitsList* = Call_AdsenseAdunitsList_579261(
    name: "adsenseAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdsenseAdunitsList_579262, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsList_579263, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGet_579279 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsGet_579281(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGet_579280(path: JsonNode; query: JsonNode;
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
  var valid_579282 = path.getOrDefault("adClientId")
  valid_579282 = validateParameter(valid_579282, JString, required = true,
                                 default = nil)
  if valid_579282 != nil:
    section.add "adClientId", valid_579282
  var valid_579283 = path.getOrDefault("adUnitId")
  valid_579283 = validateParameter(valid_579283, JString, required = true,
                                 default = nil)
  if valid_579283 != nil:
    section.add "adUnitId", valid_579283
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579284 = query.getOrDefault("key")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "key", valid_579284
  var valid_579285 = query.getOrDefault("prettyPrint")
  valid_579285 = validateParameter(valid_579285, JBool, required = false,
                                 default = newJBool(true))
  if valid_579285 != nil:
    section.add "prettyPrint", valid_579285
  var valid_579286 = query.getOrDefault("oauth_token")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "oauth_token", valid_579286
  var valid_579287 = query.getOrDefault("alt")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = newJString("json"))
  if valid_579287 != nil:
    section.add "alt", valid_579287
  var valid_579288 = query.getOrDefault("userIp")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "userIp", valid_579288
  var valid_579289 = query.getOrDefault("quotaUser")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "quotaUser", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579291: Call_AdsenseAdunitsGet_579279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_579291.validator(path, query, header, formData, body)
  let scheme = call_579291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579291.url(scheme.get, call_579291.host, call_579291.base,
                         call_579291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579291, url, valid)

proc call*(call_579292: Call_AdsenseAdunitsGet_579279; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client for which to get the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579293 = newJObject()
  var query_579294 = newJObject()
  add(query_579294, "key", newJString(key))
  add(query_579294, "prettyPrint", newJBool(prettyPrint))
  add(query_579294, "oauth_token", newJString(oauthToken))
  add(query_579294, "alt", newJString(alt))
  add(query_579294, "userIp", newJString(userIp))
  add(query_579294, "quotaUser", newJString(quotaUser))
  add(path_579293, "adClientId", newJString(adClientId))
  add(path_579293, "adUnitId", newJString(adUnitId))
  add(query_579294, "fields", newJString(fields))
  result = call_579292.call(path_579293, query_579294, nil, nil, nil)

var adsenseAdunitsGet* = Call_AdsenseAdunitsGet_579279(name: "adsenseAdunitsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsenseAdunitsGet_579280, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsGet_579281, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsGetAdCode_579295 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsGetAdCode_579297(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAdunitsGetAdCode_579296(path: JsonNode; query: JsonNode;
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
  var valid_579298 = path.getOrDefault("adClientId")
  valid_579298 = validateParameter(valid_579298, JString, required = true,
                                 default = nil)
  if valid_579298 != nil:
    section.add "adClientId", valid_579298
  var valid_579299 = path.getOrDefault("adUnitId")
  valid_579299 = validateParameter(valid_579299, JString, required = true,
                                 default = nil)
  if valid_579299 != nil:
    section.add "adUnitId", valid_579299
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579300 = query.getOrDefault("key")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "key", valid_579300
  var valid_579301 = query.getOrDefault("prettyPrint")
  valid_579301 = validateParameter(valid_579301, JBool, required = false,
                                 default = newJBool(true))
  if valid_579301 != nil:
    section.add "prettyPrint", valid_579301
  var valid_579302 = query.getOrDefault("oauth_token")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "oauth_token", valid_579302
  var valid_579303 = query.getOrDefault("alt")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = newJString("json"))
  if valid_579303 != nil:
    section.add "alt", valid_579303
  var valid_579304 = query.getOrDefault("userIp")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "userIp", valid_579304
  var valid_579305 = query.getOrDefault("quotaUser")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "quotaUser", valid_579305
  var valid_579306 = query.getOrDefault("fields")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "fields", valid_579306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579307: Call_AdsenseAdunitsGetAdCode_579295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit.
  ## 
  let valid = call_579307.validator(path, query, header, formData, body)
  let scheme = call_579307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579307.url(scheme.get, call_579307.host, call_579307.base,
                         call_579307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579307, url, valid)

proc call*(call_579308: Call_AdsenseAdunitsGetAdCode_579295; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579309 = newJObject()
  var query_579310 = newJObject()
  add(query_579310, "key", newJString(key))
  add(query_579310, "prettyPrint", newJBool(prettyPrint))
  add(query_579310, "oauth_token", newJString(oauthToken))
  add(query_579310, "alt", newJString(alt))
  add(query_579310, "userIp", newJString(userIp))
  add(query_579310, "quotaUser", newJString(quotaUser))
  add(path_579309, "adClientId", newJString(adClientId))
  add(path_579309, "adUnitId", newJString(adUnitId))
  add(query_579310, "fields", newJString(fields))
  result = call_579308.call(path_579309, query_579310, nil, nil, nil)

var adsenseAdunitsGetAdCode* = Call_AdsenseAdunitsGetAdCode_579295(
    name: "adsenseAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsenseAdunitsGetAdCode_579296, base: "/adsense/v1.4",
    url: url_AdsenseAdunitsGetAdCode_579297, schemes: {Scheme.Https})
type
  Call_AdsenseAdunitsCustomchannelsList_579311 = ref object of OpenApiRestCall_578355
proc url_AdsenseAdunitsCustomchannelsList_579313(protocol: Scheme; host: string;
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

proc validate_AdsenseAdunitsCustomchannelsList_579312(path: JsonNode;
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
  var valid_579314 = path.getOrDefault("adClientId")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "adClientId", valid_579314
  var valid_579315 = path.getOrDefault("adUnitId")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "adUnitId", valid_579315
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579316 = query.getOrDefault("key")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "key", valid_579316
  var valid_579317 = query.getOrDefault("prettyPrint")
  valid_579317 = validateParameter(valid_579317, JBool, required = false,
                                 default = newJBool(true))
  if valid_579317 != nil:
    section.add "prettyPrint", valid_579317
  var valid_579318 = query.getOrDefault("oauth_token")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "oauth_token", valid_579318
  var valid_579319 = query.getOrDefault("alt")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = newJString("json"))
  if valid_579319 != nil:
    section.add "alt", valid_579319
  var valid_579320 = query.getOrDefault("userIp")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "userIp", valid_579320
  var valid_579321 = query.getOrDefault("quotaUser")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "quotaUser", valid_579321
  var valid_579322 = query.getOrDefault("pageToken")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "pageToken", valid_579322
  var valid_579323 = query.getOrDefault("fields")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "fields", valid_579323
  var valid_579324 = query.getOrDefault("maxResults")
  valid_579324 = validateParameter(valid_579324, JInt, required = false, default = nil)
  if valid_579324 != nil:
    section.add "maxResults", valid_579324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579325: Call_AdsenseAdunitsCustomchannelsList_579311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_579325.validator(path, query, header, formData, body)
  let scheme = call_579325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579325.url(scheme.get, call_579325.host, call_579325.base,
                         call_579325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579325, url, valid)

proc call*(call_579326: Call_AdsenseAdunitsCustomchannelsList_579311;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579327 = newJObject()
  var query_579328 = newJObject()
  add(query_579328, "key", newJString(key))
  add(query_579328, "prettyPrint", newJBool(prettyPrint))
  add(query_579328, "oauth_token", newJString(oauthToken))
  add(query_579328, "alt", newJString(alt))
  add(query_579328, "userIp", newJString(userIp))
  add(query_579328, "quotaUser", newJString(quotaUser))
  add(query_579328, "pageToken", newJString(pageToken))
  add(path_579327, "adClientId", newJString(adClientId))
  add(path_579327, "adUnitId", newJString(adUnitId))
  add(query_579328, "fields", newJString(fields))
  add(query_579328, "maxResults", newJInt(maxResults))
  result = call_579326.call(path_579327, query_579328, nil, nil, nil)

var adsenseAdunitsCustomchannelsList* = Call_AdsenseAdunitsCustomchannelsList_579311(
    name: "adsenseAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdsenseAdunitsCustomchannelsList_579312,
    base: "/adsense/v1.4", url: url_AdsenseAdunitsCustomchannelsList_579313,
    schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsList_579329 = ref object of OpenApiRestCall_578355
proc url_AdsenseCustomchannelsList_579331(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsList_579330(path: JsonNode; query: JsonNode;
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
  var valid_579332 = path.getOrDefault("adClientId")
  valid_579332 = validateParameter(valid_579332, JString, required = true,
                                 default = nil)
  if valid_579332 != nil:
    section.add "adClientId", valid_579332
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of custom channels to include in the response, used for paging.
  section = newJObject()
  var valid_579333 = query.getOrDefault("key")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "key", valid_579333
  var valid_579334 = query.getOrDefault("prettyPrint")
  valid_579334 = validateParameter(valid_579334, JBool, required = false,
                                 default = newJBool(true))
  if valid_579334 != nil:
    section.add "prettyPrint", valid_579334
  var valid_579335 = query.getOrDefault("oauth_token")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "oauth_token", valid_579335
  var valid_579336 = query.getOrDefault("alt")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = newJString("json"))
  if valid_579336 != nil:
    section.add "alt", valid_579336
  var valid_579337 = query.getOrDefault("userIp")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "userIp", valid_579337
  var valid_579338 = query.getOrDefault("quotaUser")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "quotaUser", valid_579338
  var valid_579339 = query.getOrDefault("pageToken")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "pageToken", valid_579339
  var valid_579340 = query.getOrDefault("fields")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "fields", valid_579340
  var valid_579341 = query.getOrDefault("maxResults")
  valid_579341 = validateParameter(valid_579341, JInt, required = false, default = nil)
  if valid_579341 != nil:
    section.add "maxResults", valid_579341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579342: Call_AdsenseCustomchannelsList_579329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_579342.validator(path, query, header, formData, body)
  let scheme = call_579342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579342.url(scheme.get, call_579342.host, call_579342.base,
                         call_579342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579342, url, valid)

proc call*(call_579343: Call_AdsenseCustomchannelsList_579329; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through custom channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list custom channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of custom channels to include in the response, used for paging.
  var path_579344 = newJObject()
  var query_579345 = newJObject()
  add(query_579345, "key", newJString(key))
  add(query_579345, "prettyPrint", newJBool(prettyPrint))
  add(query_579345, "oauth_token", newJString(oauthToken))
  add(query_579345, "alt", newJString(alt))
  add(query_579345, "userIp", newJString(userIp))
  add(query_579345, "quotaUser", newJString(quotaUser))
  add(query_579345, "pageToken", newJString(pageToken))
  add(path_579344, "adClientId", newJString(adClientId))
  add(query_579345, "fields", newJString(fields))
  add(query_579345, "maxResults", newJInt(maxResults))
  result = call_579343.call(path_579344, query_579345, nil, nil, nil)

var adsenseCustomchannelsList* = Call_AdsenseCustomchannelsList_579329(
    name: "adsenseCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsenseCustomchannelsList_579330, base: "/adsense/v1.4",
    url: url_AdsenseCustomchannelsList_579331, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsGet_579346 = ref object of OpenApiRestCall_578355
proc url_AdsenseCustomchannelsGet_579348(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsGet_579347(path: JsonNode; query: JsonNode;
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
  var valid_579349 = path.getOrDefault("adClientId")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = nil)
  if valid_579349 != nil:
    section.add "adClientId", valid_579349
  var valid_579350 = path.getOrDefault("customChannelId")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "customChannelId", valid_579350
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579351 = query.getOrDefault("key")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "key", valid_579351
  var valid_579352 = query.getOrDefault("prettyPrint")
  valid_579352 = validateParameter(valid_579352, JBool, required = false,
                                 default = newJBool(true))
  if valid_579352 != nil:
    section.add "prettyPrint", valid_579352
  var valid_579353 = query.getOrDefault("oauth_token")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "oauth_token", valid_579353
  var valid_579354 = query.getOrDefault("alt")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = newJString("json"))
  if valid_579354 != nil:
    section.add "alt", valid_579354
  var valid_579355 = query.getOrDefault("userIp")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "userIp", valid_579355
  var valid_579356 = query.getOrDefault("quotaUser")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "quotaUser", valid_579356
  var valid_579357 = query.getOrDefault("fields")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "fields", valid_579357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579358: Call_AdsenseCustomchannelsGet_579346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_AdsenseCustomchannelsGet_579346; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   adClientId: string (required)
  ##             : Ad client which contains the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "userIp", newJString(userIp))
  add(query_579361, "quotaUser", newJString(quotaUser))
  add(path_579360, "adClientId", newJString(adClientId))
  add(path_579360, "customChannelId", newJString(customChannelId))
  add(query_579361, "fields", newJString(fields))
  result = call_579359.call(path_579360, query_579361, nil, nil, nil)

var adsenseCustomchannelsGet* = Call_AdsenseCustomchannelsGet_579346(
    name: "adsenseCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsenseCustomchannelsGet_579347, base: "/adsense/v1.4",
    url: url_AdsenseCustomchannelsGet_579348, schemes: {Scheme.Https})
type
  Call_AdsenseCustomchannelsAdunitsList_579362 = ref object of OpenApiRestCall_578355
proc url_AdsenseCustomchannelsAdunitsList_579364(protocol: Scheme; host: string;
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

proc validate_AdsenseCustomchannelsAdunitsList_579363(path: JsonNode;
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
  var valid_579365 = path.getOrDefault("adClientId")
  valid_579365 = validateParameter(valid_579365, JString, required = true,
                                 default = nil)
  if valid_579365 != nil:
    section.add "adClientId", valid_579365
  var valid_579366 = path.getOrDefault("customChannelId")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "customChannelId", valid_579366
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through ad units. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   includeInactive: JBool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of ad units to include in the response, used for paging.
  section = newJObject()
  var valid_579367 = query.getOrDefault("key")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "key", valid_579367
  var valid_579368 = query.getOrDefault("prettyPrint")
  valid_579368 = validateParameter(valid_579368, JBool, required = false,
                                 default = newJBool(true))
  if valid_579368 != nil:
    section.add "prettyPrint", valid_579368
  var valid_579369 = query.getOrDefault("oauth_token")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "oauth_token", valid_579369
  var valid_579370 = query.getOrDefault("alt")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = newJString("json"))
  if valid_579370 != nil:
    section.add "alt", valid_579370
  var valid_579371 = query.getOrDefault("userIp")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "userIp", valid_579371
  var valid_579372 = query.getOrDefault("quotaUser")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "quotaUser", valid_579372
  var valid_579373 = query.getOrDefault("pageToken")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "pageToken", valid_579373
  var valid_579374 = query.getOrDefault("includeInactive")
  valid_579374 = validateParameter(valid_579374, JBool, required = false, default = nil)
  if valid_579374 != nil:
    section.add "includeInactive", valid_579374
  var valid_579375 = query.getOrDefault("fields")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "fields", valid_579375
  var valid_579376 = query.getOrDefault("maxResults")
  valid_579376 = validateParameter(valid_579376, JInt, required = false, default = nil)
  if valid_579376 != nil:
    section.add "maxResults", valid_579376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579377: Call_AdsenseCustomchannelsAdunitsList_579362;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_579377.validator(path, query, header, formData, body)
  let scheme = call_579377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579377.url(scheme.get, call_579377.host, call_579377.base,
                         call_579377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579377, url, valid)

proc call*(call_579378: Call_AdsenseCustomchannelsAdunitsList_579362;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var path_579379 = newJObject()
  var query_579380 = newJObject()
  add(query_579380, "key", newJString(key))
  add(query_579380, "prettyPrint", newJBool(prettyPrint))
  add(query_579380, "oauth_token", newJString(oauthToken))
  add(query_579380, "alt", newJString(alt))
  add(query_579380, "userIp", newJString(userIp))
  add(query_579380, "quotaUser", newJString(quotaUser))
  add(query_579380, "pageToken", newJString(pageToken))
  add(path_579379, "adClientId", newJString(adClientId))
  add(path_579379, "customChannelId", newJString(customChannelId))
  add(query_579380, "includeInactive", newJBool(includeInactive))
  add(query_579380, "fields", newJString(fields))
  add(query_579380, "maxResults", newJInt(maxResults))
  result = call_579378.call(path_579379, query_579380, nil, nil, nil)

var adsenseCustomchannelsAdunitsList* = Call_AdsenseCustomchannelsAdunitsList_579362(
    name: "adsenseCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdsenseCustomchannelsAdunitsList_579363,
    base: "/adsense/v1.4", url: url_AdsenseCustomchannelsAdunitsList_579364,
    schemes: {Scheme.Https})
type
  Call_AdsenseUrlchannelsList_579381 = ref object of OpenApiRestCall_578355
proc url_AdsenseUrlchannelsList_579383(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseUrlchannelsList_579382(path: JsonNode; query: JsonNode;
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
  var valid_579384 = path.getOrDefault("adClientId")
  valid_579384 = validateParameter(valid_579384, JString, required = true,
                                 default = nil)
  if valid_579384 != nil:
    section.add "adClientId", valid_579384
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of URL channels to include in the response, used for paging.
  section = newJObject()
  var valid_579385 = query.getOrDefault("key")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "key", valid_579385
  var valid_579386 = query.getOrDefault("prettyPrint")
  valid_579386 = validateParameter(valid_579386, JBool, required = false,
                                 default = newJBool(true))
  if valid_579386 != nil:
    section.add "prettyPrint", valid_579386
  var valid_579387 = query.getOrDefault("oauth_token")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = nil)
  if valid_579387 != nil:
    section.add "oauth_token", valid_579387
  var valid_579388 = query.getOrDefault("alt")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = newJString("json"))
  if valid_579388 != nil:
    section.add "alt", valid_579388
  var valid_579389 = query.getOrDefault("userIp")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "userIp", valid_579389
  var valid_579390 = query.getOrDefault("quotaUser")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "quotaUser", valid_579390
  var valid_579391 = query.getOrDefault("pageToken")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "pageToken", valid_579391
  var valid_579392 = query.getOrDefault("fields")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "fields", valid_579392
  var valid_579393 = query.getOrDefault("maxResults")
  valid_579393 = validateParameter(valid_579393, JInt, required = false, default = nil)
  if valid_579393 != nil:
    section.add "maxResults", valid_579393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579394: Call_AdsenseUrlchannelsList_579381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this AdSense account.
  ## 
  let valid = call_579394.validator(path, query, header, formData, body)
  let scheme = call_579394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579394.url(scheme.get, call_579394.host, call_579394.base,
                         call_579394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579394, url, valid)

proc call*(call_579395: Call_AdsenseUrlchannelsList_579381; adClientId: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through URL channels. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   adClientId: string (required)
  ##             : Ad client for which to list URL channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of URL channels to include in the response, used for paging.
  var path_579396 = newJObject()
  var query_579397 = newJObject()
  add(query_579397, "key", newJString(key))
  add(query_579397, "prettyPrint", newJBool(prettyPrint))
  add(query_579397, "oauth_token", newJString(oauthToken))
  add(query_579397, "alt", newJString(alt))
  add(query_579397, "userIp", newJString(userIp))
  add(query_579397, "quotaUser", newJString(quotaUser))
  add(query_579397, "pageToken", newJString(pageToken))
  add(path_579396, "adClientId", newJString(adClientId))
  add(query_579397, "fields", newJString(fields))
  add(query_579397, "maxResults", newJInt(maxResults))
  result = call_579395.call(path_579396, query_579397, nil, nil, nil)

var adsenseUrlchannelsList* = Call_AdsenseUrlchannelsList_579381(
    name: "adsenseUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsenseUrlchannelsList_579382, base: "/adsense/v1.4",
    url: url_AdsenseUrlchannelsList_579383, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsList_579398 = ref object of OpenApiRestCall_578355
proc url_AdsenseAlertsList_579400(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseAlertsList_579399(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579401 = query.getOrDefault("key")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "key", valid_579401
  var valid_579402 = query.getOrDefault("prettyPrint")
  valid_579402 = validateParameter(valid_579402, JBool, required = false,
                                 default = newJBool(true))
  if valid_579402 != nil:
    section.add "prettyPrint", valid_579402
  var valid_579403 = query.getOrDefault("oauth_token")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "oauth_token", valid_579403
  var valid_579404 = query.getOrDefault("locale")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "locale", valid_579404
  var valid_579405 = query.getOrDefault("alt")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = newJString("json"))
  if valid_579405 != nil:
    section.add "alt", valid_579405
  var valid_579406 = query.getOrDefault("userIp")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "userIp", valid_579406
  var valid_579407 = query.getOrDefault("quotaUser")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "quotaUser", valid_579407
  var valid_579408 = query.getOrDefault("fields")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "fields", valid_579408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579409: Call_AdsenseAlertsList_579398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this AdSense account.
  ## 
  let valid = call_579409.validator(path, query, header, formData, body)
  let scheme = call_579409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579409.url(scheme.get, call_579409.host, call_579409.base,
                         call_579409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579409, url, valid)

proc call*(call_579410: Call_AdsenseAlertsList_579398; key: string = "";
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579411 = newJObject()
  add(query_579411, "key", newJString(key))
  add(query_579411, "prettyPrint", newJBool(prettyPrint))
  add(query_579411, "oauth_token", newJString(oauthToken))
  add(query_579411, "locale", newJString(locale))
  add(query_579411, "alt", newJString(alt))
  add(query_579411, "userIp", newJString(userIp))
  add(query_579411, "quotaUser", newJString(quotaUser))
  add(query_579411, "fields", newJString(fields))
  result = call_579410.call(nil, query_579411, nil, nil, nil)

var adsenseAlertsList* = Call_AdsenseAlertsList_579398(name: "adsenseAlertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdsenseAlertsList_579399, base: "/adsense/v1.4",
    url: url_AdsenseAlertsList_579400, schemes: {Scheme.Https})
type
  Call_AdsenseAlertsDelete_579412 = ref object of OpenApiRestCall_578355
proc url_AdsenseAlertsDelete_579414(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseAlertsDelete_579413(path: JsonNode; query: JsonNode;
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
  var valid_579415 = path.getOrDefault("alertId")
  valid_579415 = validateParameter(valid_579415, JString, required = true,
                                 default = nil)
  if valid_579415 != nil:
    section.add "alertId", valid_579415
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579416 = query.getOrDefault("key")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "key", valid_579416
  var valid_579417 = query.getOrDefault("prettyPrint")
  valid_579417 = validateParameter(valid_579417, JBool, required = false,
                                 default = newJBool(true))
  if valid_579417 != nil:
    section.add "prettyPrint", valid_579417
  var valid_579418 = query.getOrDefault("oauth_token")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "oauth_token", valid_579418
  var valid_579419 = query.getOrDefault("alt")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = newJString("json"))
  if valid_579419 != nil:
    section.add "alt", valid_579419
  var valid_579420 = query.getOrDefault("userIp")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "userIp", valid_579420
  var valid_579421 = query.getOrDefault("quotaUser")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "quotaUser", valid_579421
  var valid_579422 = query.getOrDefault("fields")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "fields", valid_579422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579423: Call_AdsenseAlertsDelete_579412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Dismiss (delete) the specified alert from the publisher's AdSense account.
  ## 
  let valid = call_579423.validator(path, query, header, formData, body)
  let scheme = call_579423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579423.url(scheme.get, call_579423.host, call_579423.base,
                         call_579423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579423, url, valid)

proc call*(call_579424: Call_AdsenseAlertsDelete_579412; alertId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsenseAlertsDelete
  ## Dismiss (delete) the specified alert from the publisher's AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alertId: string (required)
  ##          : Alert to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579425 = newJObject()
  var query_579426 = newJObject()
  add(query_579426, "key", newJString(key))
  add(query_579426, "prettyPrint", newJBool(prettyPrint))
  add(query_579426, "oauth_token", newJString(oauthToken))
  add(path_579425, "alertId", newJString(alertId))
  add(query_579426, "alt", newJString(alt))
  add(query_579426, "userIp", newJString(userIp))
  add(query_579426, "quotaUser", newJString(quotaUser))
  add(query_579426, "fields", newJString(fields))
  result = call_579424.call(path_579425, query_579426, nil, nil, nil)

var adsenseAlertsDelete* = Call_AdsenseAlertsDelete_579412(
    name: "adsenseAlertsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/alerts/{alertId}",
    validator: validate_AdsenseAlertsDelete_579413, base: "/adsense/v1.4",
    url: url_AdsenseAlertsDelete_579414, schemes: {Scheme.Https})
type
  Call_AdsenseMetadataDimensionsList_579427 = ref object of OpenApiRestCall_578355
proc url_AdsenseMetadataDimensionsList_579429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataDimensionsList_579428(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579430 = query.getOrDefault("key")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "key", valid_579430
  var valid_579431 = query.getOrDefault("prettyPrint")
  valid_579431 = validateParameter(valid_579431, JBool, required = false,
                                 default = newJBool(true))
  if valid_579431 != nil:
    section.add "prettyPrint", valid_579431
  var valid_579432 = query.getOrDefault("oauth_token")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "oauth_token", valid_579432
  var valid_579433 = query.getOrDefault("alt")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = newJString("json"))
  if valid_579433 != nil:
    section.add "alt", valid_579433
  var valid_579434 = query.getOrDefault("userIp")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "userIp", valid_579434
  var valid_579435 = query.getOrDefault("quotaUser")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "quotaUser", valid_579435
  var valid_579436 = query.getOrDefault("fields")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "fields", valid_579436
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579437: Call_AdsenseMetadataDimensionsList_579427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdSense account.
  ## 
  let valid = call_579437.validator(path, query, header, formData, body)
  let scheme = call_579437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579437.url(scheme.get, call_579437.host, call_579437.base,
                         call_579437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579437, url, valid)

proc call*(call_579438: Call_AdsenseMetadataDimensionsList_579427;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579439 = newJObject()
  add(query_579439, "key", newJString(key))
  add(query_579439, "prettyPrint", newJBool(prettyPrint))
  add(query_579439, "oauth_token", newJString(oauthToken))
  add(query_579439, "alt", newJString(alt))
  add(query_579439, "userIp", newJString(userIp))
  add(query_579439, "quotaUser", newJString(quotaUser))
  add(query_579439, "fields", newJString(fields))
  result = call_579438.call(nil, query_579439, nil, nil, nil)

var adsenseMetadataDimensionsList* = Call_AdsenseMetadataDimensionsList_579427(
    name: "adsenseMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdsenseMetadataDimensionsList_579428,
    base: "/adsense/v1.4", url: url_AdsenseMetadataDimensionsList_579429,
    schemes: {Scheme.Https})
type
  Call_AdsenseMetadataMetricsList_579440 = ref object of OpenApiRestCall_578355
proc url_AdsenseMetadataMetricsList_579442(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseMetadataMetricsList_579441(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579443 = query.getOrDefault("key")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "key", valid_579443
  var valid_579444 = query.getOrDefault("prettyPrint")
  valid_579444 = validateParameter(valid_579444, JBool, required = false,
                                 default = newJBool(true))
  if valid_579444 != nil:
    section.add "prettyPrint", valid_579444
  var valid_579445 = query.getOrDefault("oauth_token")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "oauth_token", valid_579445
  var valid_579446 = query.getOrDefault("alt")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = newJString("json"))
  if valid_579446 != nil:
    section.add "alt", valid_579446
  var valid_579447 = query.getOrDefault("userIp")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "userIp", valid_579447
  var valid_579448 = query.getOrDefault("quotaUser")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "quotaUser", valid_579448
  var valid_579449 = query.getOrDefault("fields")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "fields", valid_579449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579450: Call_AdsenseMetadataMetricsList_579440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdSense account.
  ## 
  let valid = call_579450.validator(path, query, header, formData, body)
  let scheme = call_579450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579450.url(scheme.get, call_579450.host, call_579450.base,
                         call_579450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579450, url, valid)

proc call*(call_579451: Call_AdsenseMetadataMetricsList_579440; key: string = "";
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579452 = newJObject()
  add(query_579452, "key", newJString(key))
  add(query_579452, "prettyPrint", newJBool(prettyPrint))
  add(query_579452, "oauth_token", newJString(oauthToken))
  add(query_579452, "alt", newJString(alt))
  add(query_579452, "userIp", newJString(userIp))
  add(query_579452, "quotaUser", newJString(quotaUser))
  add(query_579452, "fields", newJString(fields))
  result = call_579451.call(nil, query_579452, nil, nil, nil)

var adsenseMetadataMetricsList* = Call_AdsenseMetadataMetricsList_579440(
    name: "adsenseMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdsenseMetadataMetricsList_579441, base: "/adsense/v1.4",
    url: url_AdsenseMetadataMetricsList_579442, schemes: {Scheme.Https})
type
  Call_AdsensePaymentsList_579453 = ref object of OpenApiRestCall_578355
proc url_AdsensePaymentsList_579455(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensePaymentsList_579454(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List the payments for this AdSense account.
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579456 = query.getOrDefault("key")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "key", valid_579456
  var valid_579457 = query.getOrDefault("prettyPrint")
  valid_579457 = validateParameter(valid_579457, JBool, required = false,
                                 default = newJBool(true))
  if valid_579457 != nil:
    section.add "prettyPrint", valid_579457
  var valid_579458 = query.getOrDefault("oauth_token")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "oauth_token", valid_579458
  var valid_579459 = query.getOrDefault("alt")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = newJString("json"))
  if valid_579459 != nil:
    section.add "alt", valid_579459
  var valid_579460 = query.getOrDefault("userIp")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "userIp", valid_579460
  var valid_579461 = query.getOrDefault("quotaUser")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "quotaUser", valid_579461
  var valid_579462 = query.getOrDefault("fields")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "fields", valid_579462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579463: Call_AdsensePaymentsList_579453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the payments for this AdSense account.
  ## 
  let valid = call_579463.validator(path, query, header, formData, body)
  let scheme = call_579463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579463.url(scheme.get, call_579463.host, call_579463.base,
                         call_579463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579463, url, valid)

proc call*(call_579464: Call_AdsensePaymentsList_579453; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensePaymentsList
  ## List the payments for this AdSense account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579465 = newJObject()
  add(query_579465, "key", newJString(key))
  add(query_579465, "prettyPrint", newJBool(prettyPrint))
  add(query_579465, "oauth_token", newJString(oauthToken))
  add(query_579465, "alt", newJString(alt))
  add(query_579465, "userIp", newJString(userIp))
  add(query_579465, "quotaUser", newJString(quotaUser))
  add(query_579465, "fields", newJString(fields))
  result = call_579464.call(nil, query_579465, nil, nil, nil)

var adsensePaymentsList* = Call_AdsensePaymentsList_579453(
    name: "adsensePaymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/payments",
    validator: validate_AdsensePaymentsList_579454, base: "/adsense/v1.4",
    url: url_AdsensePaymentsList_579455, schemes: {Scheme.Https})
type
  Call_AdsenseReportsGenerate_579466 = ref object of OpenApiRestCall_578355
proc url_AdsenseReportsGenerate_579468(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsGenerate_579467(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var valid_579469 = query.getOrDefault("key")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "key", valid_579469
  var valid_579470 = query.getOrDefault("prettyPrint")
  valid_579470 = validateParameter(valid_579470, JBool, required = false,
                                 default = newJBool(true))
  if valid_579470 != nil:
    section.add "prettyPrint", valid_579470
  var valid_579471 = query.getOrDefault("oauth_token")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = nil)
  if valid_579471 != nil:
    section.add "oauth_token", valid_579471
  var valid_579472 = query.getOrDefault("locale")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "locale", valid_579472
  var valid_579473 = query.getOrDefault("currency")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "currency", valid_579473
  var valid_579474 = query.getOrDefault("alt")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = newJString("json"))
  if valid_579474 != nil:
    section.add "alt", valid_579474
  var valid_579475 = query.getOrDefault("userIp")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "userIp", valid_579475
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579476 = query.getOrDefault("endDate")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "endDate", valid_579476
  var valid_579477 = query.getOrDefault("quotaUser")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "quotaUser", valid_579477
  var valid_579478 = query.getOrDefault("startIndex")
  valid_579478 = validateParameter(valid_579478, JInt, required = false, default = nil)
  if valid_579478 != nil:
    section.add "startIndex", valid_579478
  var valid_579479 = query.getOrDefault("filter")
  valid_579479 = validateParameter(valid_579479, JArray, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "filter", valid_579479
  var valid_579480 = query.getOrDefault("useTimezoneReporting")
  valid_579480 = validateParameter(valid_579480, JBool, required = false, default = nil)
  if valid_579480 != nil:
    section.add "useTimezoneReporting", valid_579480
  var valid_579481 = query.getOrDefault("dimension")
  valid_579481 = validateParameter(valid_579481, JArray, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "dimension", valid_579481
  var valid_579482 = query.getOrDefault("metric")
  valid_579482 = validateParameter(valid_579482, JArray, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "metric", valid_579482
  var valid_579483 = query.getOrDefault("fields")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "fields", valid_579483
  var valid_579484 = query.getOrDefault("startDate")
  valid_579484 = validateParameter(valid_579484, JString, required = true,
                                 default = nil)
  if valid_579484 != nil:
    section.add "startDate", valid_579484
  var valid_579485 = query.getOrDefault("accountId")
  valid_579485 = validateParameter(valid_579485, JArray, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "accountId", valid_579485
  var valid_579486 = query.getOrDefault("maxResults")
  valid_579486 = validateParameter(valid_579486, JInt, required = false, default = nil)
  if valid_579486 != nil:
    section.add "maxResults", valid_579486
  var valid_579487 = query.getOrDefault("sort")
  valid_579487 = validateParameter(valid_579487, JArray, required = false,
                                 default = nil)
  if valid_579487 != nil:
    section.add "sort", valid_579487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579488: Call_AdsenseReportsGenerate_579466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579488.validator(path, query, header, formData, body)
  let scheme = call_579488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579488.url(scheme.get, call_579488.host, call_579488.base,
                         call_579488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579488, url, valid)

proc call*(call_579489: Call_AdsenseReportsGenerate_579466; endDate: string;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
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
  var query_579490 = newJObject()
  add(query_579490, "key", newJString(key))
  add(query_579490, "prettyPrint", newJBool(prettyPrint))
  add(query_579490, "oauth_token", newJString(oauthToken))
  add(query_579490, "locale", newJString(locale))
  add(query_579490, "currency", newJString(currency))
  add(query_579490, "alt", newJString(alt))
  add(query_579490, "userIp", newJString(userIp))
  add(query_579490, "endDate", newJString(endDate))
  add(query_579490, "quotaUser", newJString(quotaUser))
  add(query_579490, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579490.add "filter", filter
  add(query_579490, "useTimezoneReporting", newJBool(useTimezoneReporting))
  if dimension != nil:
    query_579490.add "dimension", dimension
  if metric != nil:
    query_579490.add "metric", metric
  add(query_579490, "fields", newJString(fields))
  add(query_579490, "startDate", newJString(startDate))
  if accountId != nil:
    query_579490.add "accountId", accountId
  add(query_579490, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579490.add "sort", sort
  result = call_579489.call(nil, query_579490, nil, nil, nil)

var adsenseReportsGenerate* = Call_AdsenseReportsGenerate_579466(
    name: "adsenseReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsenseReportsGenerate_579467, base: "/adsense/v1.4",
    url: url_AdsenseReportsGenerate_579468, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedList_579491 = ref object of OpenApiRestCall_578355
proc url_AdsenseReportsSavedList_579493(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseReportsSavedList_579492(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved reports to include in the response, used for paging.
  section = newJObject()
  var valid_579494 = query.getOrDefault("key")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "key", valid_579494
  var valid_579495 = query.getOrDefault("prettyPrint")
  valid_579495 = validateParameter(valid_579495, JBool, required = false,
                                 default = newJBool(true))
  if valid_579495 != nil:
    section.add "prettyPrint", valid_579495
  var valid_579496 = query.getOrDefault("oauth_token")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "oauth_token", valid_579496
  var valid_579497 = query.getOrDefault("alt")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = newJString("json"))
  if valid_579497 != nil:
    section.add "alt", valid_579497
  var valid_579498 = query.getOrDefault("userIp")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "userIp", valid_579498
  var valid_579499 = query.getOrDefault("quotaUser")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "quotaUser", valid_579499
  var valid_579500 = query.getOrDefault("pageToken")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "pageToken", valid_579500
  var valid_579501 = query.getOrDefault("fields")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "fields", valid_579501
  var valid_579502 = query.getOrDefault("maxResults")
  valid_579502 = validateParameter(valid_579502, JInt, required = false, default = nil)
  if valid_579502 != nil:
    section.add "maxResults", valid_579502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579503: Call_AdsenseReportsSavedList_579491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved reports in this AdSense account.
  ## 
  let valid = call_579503.validator(path, query, header, formData, body)
  let scheme = call_579503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579503.url(scheme.get, call_579503.host, call_579503.base,
                         call_579503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579503, url, valid)

proc call*(call_579504: Call_AdsenseReportsSavedList_579491; key: string = "";
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved reports. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved reports to include in the response, used for paging.
  var query_579505 = newJObject()
  add(query_579505, "key", newJString(key))
  add(query_579505, "prettyPrint", newJBool(prettyPrint))
  add(query_579505, "oauth_token", newJString(oauthToken))
  add(query_579505, "alt", newJString(alt))
  add(query_579505, "userIp", newJString(userIp))
  add(query_579505, "quotaUser", newJString(quotaUser))
  add(query_579505, "pageToken", newJString(pageToken))
  add(query_579505, "fields", newJString(fields))
  add(query_579505, "maxResults", newJInt(maxResults))
  result = call_579504.call(nil, query_579505, nil, nil, nil)

var adsenseReportsSavedList* = Call_AdsenseReportsSavedList_579491(
    name: "adsenseReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdsenseReportsSavedList_579492, base: "/adsense/v1.4",
    url: url_AdsenseReportsSavedList_579493, schemes: {Scheme.Https})
type
  Call_AdsenseReportsSavedGenerate_579506 = ref object of OpenApiRestCall_578355
proc url_AdsenseReportsSavedGenerate_579508(protocol: Scheme; host: string;
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

proc validate_AdsenseReportsSavedGenerate_579507(path: JsonNode; query: JsonNode;
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
  var valid_579509 = path.getOrDefault("savedReportId")
  valid_579509 = validateParameter(valid_579509, JString, required = true,
                                 default = nil)
  if valid_579509 != nil:
    section.add "savedReportId", valid_579509
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of rows of report data to return.
  section = newJObject()
  var valid_579510 = query.getOrDefault("key")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "key", valid_579510
  var valid_579511 = query.getOrDefault("prettyPrint")
  valid_579511 = validateParameter(valid_579511, JBool, required = false,
                                 default = newJBool(true))
  if valid_579511 != nil:
    section.add "prettyPrint", valid_579511
  var valid_579512 = query.getOrDefault("oauth_token")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "oauth_token", valid_579512
  var valid_579513 = query.getOrDefault("locale")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "locale", valid_579513
  var valid_579514 = query.getOrDefault("alt")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = newJString("json"))
  if valid_579514 != nil:
    section.add "alt", valid_579514
  var valid_579515 = query.getOrDefault("userIp")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "userIp", valid_579515
  var valid_579516 = query.getOrDefault("quotaUser")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "quotaUser", valid_579516
  var valid_579517 = query.getOrDefault("startIndex")
  valid_579517 = validateParameter(valid_579517, JInt, required = false, default = nil)
  if valid_579517 != nil:
    section.add "startIndex", valid_579517
  var valid_579518 = query.getOrDefault("fields")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "fields", valid_579518
  var valid_579519 = query.getOrDefault("maxResults")
  valid_579519 = validateParameter(valid_579519, JInt, required = false, default = nil)
  if valid_579519 != nil:
    section.add "maxResults", valid_579519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579520: Call_AdsenseReportsSavedGenerate_579506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579520.validator(path, query, header, formData, body)
  let scheme = call_579520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579520.url(scheme.get, call_579520.host, call_579520.base,
                         call_579520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579520, url, valid)

proc call*(call_579521: Call_AdsenseReportsSavedGenerate_579506;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   savedReportId: string (required)
  ##                : The saved report to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of rows of report data to return.
  var path_579522 = newJObject()
  var query_579523 = newJObject()
  add(query_579523, "key", newJString(key))
  add(query_579523, "prettyPrint", newJBool(prettyPrint))
  add(query_579523, "oauth_token", newJString(oauthToken))
  add(query_579523, "locale", newJString(locale))
  add(query_579523, "alt", newJString(alt))
  add(query_579523, "userIp", newJString(userIp))
  add(path_579522, "savedReportId", newJString(savedReportId))
  add(query_579523, "quotaUser", newJString(quotaUser))
  add(query_579523, "startIndex", newJInt(startIndex))
  add(query_579523, "fields", newJString(fields))
  add(query_579523, "maxResults", newJInt(maxResults))
  result = call_579521.call(path_579522, query_579523, nil, nil, nil)

var adsenseReportsSavedGenerate* = Call_AdsenseReportsSavedGenerate_579506(
    name: "adsenseReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdsenseReportsSavedGenerate_579507, base: "/adsense/v1.4",
    url: url_AdsenseReportsSavedGenerate_579508, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesList_579524 = ref object of OpenApiRestCall_578355
proc url_AdsenseSavedadstylesList_579526(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsenseSavedadstylesList_579525(path: JsonNode; query: JsonNode;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  section = newJObject()
  var valid_579527 = query.getOrDefault("key")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "key", valid_579527
  var valid_579528 = query.getOrDefault("prettyPrint")
  valid_579528 = validateParameter(valid_579528, JBool, required = false,
                                 default = newJBool(true))
  if valid_579528 != nil:
    section.add "prettyPrint", valid_579528
  var valid_579529 = query.getOrDefault("oauth_token")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "oauth_token", valid_579529
  var valid_579530 = query.getOrDefault("alt")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = newJString("json"))
  if valid_579530 != nil:
    section.add "alt", valid_579530
  var valid_579531 = query.getOrDefault("userIp")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "userIp", valid_579531
  var valid_579532 = query.getOrDefault("quotaUser")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "quotaUser", valid_579532
  var valid_579533 = query.getOrDefault("pageToken")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "pageToken", valid_579533
  var valid_579534 = query.getOrDefault("fields")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "fields", valid_579534
  var valid_579535 = query.getOrDefault("maxResults")
  valid_579535 = validateParameter(valid_579535, JInt, required = false, default = nil)
  if valid_579535 != nil:
    section.add "maxResults", valid_579535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579536: Call_AdsenseSavedadstylesList_579524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all saved ad styles in the user's account.
  ## 
  let valid = call_579536.validator(path, query, header, formData, body)
  let scheme = call_579536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579536.url(scheme.get, call_579536.host, call_579536.base,
                         call_579536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579536, url, valid)

proc call*(call_579537: Call_AdsenseSavedadstylesList_579524; key: string = "";
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A continuation token, used to page through saved ad styles. To retrieve the next page, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of saved ad styles to include in the response, used for paging.
  var query_579538 = newJObject()
  add(query_579538, "key", newJString(key))
  add(query_579538, "prettyPrint", newJBool(prettyPrint))
  add(query_579538, "oauth_token", newJString(oauthToken))
  add(query_579538, "alt", newJString(alt))
  add(query_579538, "userIp", newJString(userIp))
  add(query_579538, "quotaUser", newJString(quotaUser))
  add(query_579538, "pageToken", newJString(pageToken))
  add(query_579538, "fields", newJString(fields))
  add(query_579538, "maxResults", newJInt(maxResults))
  result = call_579537.call(nil, query_579538, nil, nil, nil)

var adsenseSavedadstylesList* = Call_AdsenseSavedadstylesList_579524(
    name: "adsenseSavedadstylesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles",
    validator: validate_AdsenseSavedadstylesList_579525, base: "/adsense/v1.4",
    url: url_AdsenseSavedadstylesList_579526, schemes: {Scheme.Https})
type
  Call_AdsenseSavedadstylesGet_579539 = ref object of OpenApiRestCall_578355
proc url_AdsenseSavedadstylesGet_579541(protocol: Scheme; host: string; base: string;
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

proc validate_AdsenseSavedadstylesGet_579540(path: JsonNode; query: JsonNode;
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
  var valid_579542 = path.getOrDefault("savedAdStyleId")
  valid_579542 = validateParameter(valid_579542, JString, required = true,
                                 default = nil)
  if valid_579542 != nil:
    section.add "savedAdStyleId", valid_579542
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579543 = query.getOrDefault("key")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "key", valid_579543
  var valid_579544 = query.getOrDefault("prettyPrint")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(true))
  if valid_579544 != nil:
    section.add "prettyPrint", valid_579544
  var valid_579545 = query.getOrDefault("oauth_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "oauth_token", valid_579545
  var valid_579546 = query.getOrDefault("alt")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = newJString("json"))
  if valid_579546 != nil:
    section.add "alt", valid_579546
  var valid_579547 = query.getOrDefault("userIp")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "userIp", valid_579547
  var valid_579548 = query.getOrDefault("quotaUser")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "quotaUser", valid_579548
  var valid_579549 = query.getOrDefault("fields")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "fields", valid_579549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579550: Call_AdsenseSavedadstylesGet_579539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific saved ad style from the user's account.
  ## 
  let valid = call_579550.validator(path, query, header, formData, body)
  let scheme = call_579550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579550.url(scheme.get, call_579550.host, call_579550.base,
                         call_579550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579550, url, valid)

proc call*(call_579551: Call_AdsenseSavedadstylesGet_579539;
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
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   savedAdStyleId: string (required)
  ##                 : Saved ad style to retrieve.
  var path_579552 = newJObject()
  var query_579553 = newJObject()
  add(query_579553, "key", newJString(key))
  add(query_579553, "prettyPrint", newJBool(prettyPrint))
  add(query_579553, "oauth_token", newJString(oauthToken))
  add(query_579553, "alt", newJString(alt))
  add(query_579553, "userIp", newJString(userIp))
  add(query_579553, "quotaUser", newJString(quotaUser))
  add(query_579553, "fields", newJString(fields))
  add(path_579552, "savedAdStyleId", newJString(savedAdStyleId))
  result = call_579551.call(path_579552, query_579553, nil, nil, nil)

var adsenseSavedadstylesGet* = Call_AdsenseSavedadstylesGet_579539(
    name: "adsenseSavedadstylesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/savedadstyles/{savedAdStyleId}",
    validator: validate_AdsenseSavedadstylesGet_579540, base: "/adsense/v1.4",
    url: url_AdsenseSavedadstylesGet_579541, schemes: {Scheme.Https})
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
