
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: AdSense Host
## version: v4.1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Generates performance reports, generates ad codes, and provides publisher management capabilities for AdSense Hosts.
## 
## https://developers.google.com/adsense/host/
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
  gcpServiceName = "adsensehost"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdsensehostAccountsList_578626 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsList_578628(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAccountsList_578627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List hosted accounts associated with this AdSense account by ad client id.
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
  ##   filterAdClientId: JArray (required)
  ##                   : Ad clients to list accounts for.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
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
  assert query != nil,
        "query argument is necessary due to required `filterAdClientId` field"
  var valid_578756 = query.getOrDefault("filterAdClientId")
  valid_578756 = validateParameter(valid_578756, JArray, required = true, default = nil)
  if valid_578756 != nil:
    section.add "filterAdClientId", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("userIp")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "userIp", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578783: Call_AdsensehostAccountsList_578626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List hosted accounts associated with this AdSense account by ad client id.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_AdsensehostAccountsList_578626;
          filterAdClientId: JsonNode; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostAccountsList
  ## List hosted accounts associated with this AdSense account by ad client id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   filterAdClientId: JArray (required)
  ##                   : Ad clients to list accounts for.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  if filterAdClientId != nil:
    query_578855.add "filterAdClientId", filterAdClientId
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "userIp", newJString(userIp))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(query_578855, "fields", newJString(fields))
  result = call_578854.call(nil, query_578855, nil, nil, nil)

var adsensehostAccountsList* = Call_AdsensehostAccountsList_578626(
    name: "adsensehostAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts",
    validator: validate_AdsensehostAccountsList_578627, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsList_578628, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsGet_578895 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsGet_578897(protocol: Scheme; host: string; base: string;
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

proc validate_AdsensehostAccountsGet_578896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about the selected associated AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account to get information about.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578912 = path.getOrDefault("accountId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "accountId", valid_578912
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("userIp")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "userIp", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578920: Call_AdsensehostAccountsGet_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected associated AdSense account.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_AdsensehostAccountsGet_578895; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsensehostAccountsGet
  ## Get information about the selected associated AdSense account.
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
  ##            : Account to get information about.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578922 = newJObject()
  var query_578923 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "userIp", newJString(userIp))
  add(query_578923, "quotaUser", newJString(quotaUser))
  add(path_578922, "accountId", newJString(accountId))
  add(query_578923, "fields", newJString(fields))
  result = call_578921.call(path_578922, query_578923, nil, nil, nil)

var adsensehostAccountsGet* = Call_AdsensehostAccountsGet_578895(
    name: "adsensehostAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdsensehostAccountsGet_578896, base: "/adsensehost/v4.1",
    url: url_AdsensehostAccountsGet_578897, schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsList_578924 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdclientsList_578926(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdclientsList_578925(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account for which to list ad clients.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_578927 = path.getOrDefault("accountId")
  valid_578927 = validateParameter(valid_578927, JString, required = true,
                                 default = nil)
  if valid_578927 != nil:
    section.add "accountId", valid_578927
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
  var valid_578928 = query.getOrDefault("key")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "key", valid_578928
  var valid_578929 = query.getOrDefault("prettyPrint")
  valid_578929 = validateParameter(valid_578929, JBool, required = false,
                                 default = newJBool(true))
  if valid_578929 != nil:
    section.add "prettyPrint", valid_578929
  var valid_578930 = query.getOrDefault("oauth_token")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "oauth_token", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("userIp")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "userIp", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("pageToken")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "pageToken", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("maxResults")
  valid_578936 = validateParameter(valid_578936, JInt, required = false, default = nil)
  if valid_578936 != nil:
    section.add "maxResults", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_AdsensehostAccountsAdclientsList_578924;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all hosted ad clients in the specified hosted account.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_AdsensehostAccountsAdclientsList_578924;
          accountId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsensehostAccountsAdclientsList
  ## List all hosted ad clients in the specified hosted account.
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
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(query_578940, "pageToken", newJString(pageToken))
  add(path_578939, "accountId", newJString(accountId))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "maxResults", newJInt(maxResults))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var adsensehostAccountsAdclientsList* = Call_AdsensehostAccountsAdclientsList_578924(
    name: "adsensehostAccountsAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients",
    validator: validate_AdsensehostAccountsAdclientsList_578925,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsList_578926,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdclientsGet_578941 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdclientsGet_578943(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAccountsAdclientsGet_578942(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to get.
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578944 = path.getOrDefault("adClientId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "adClientId", valid_578944
  var valid_578945 = path.getOrDefault("accountId")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "accountId", valid_578945
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
  var valid_578946 = query.getOrDefault("key")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "key", valid_578946
  var valid_578947 = query.getOrDefault("prettyPrint")
  valid_578947 = validateParameter(valid_578947, JBool, required = false,
                                 default = newJBool(true))
  if valid_578947 != nil:
    section.add "prettyPrint", valid_578947
  var valid_578948 = query.getOrDefault("oauth_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "oauth_token", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("userIp")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "userIp", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578953: Call_AdsensehostAccountsAdclientsGet_578941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_AdsensehostAccountsAdclientsGet_578941;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostAccountsAdclientsGet
  ## Get information about one of the ad clients in the specified publisher's AdSense account.
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
  ##             : Ad client to get.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "userIp", newJString(userIp))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(path_578955, "adClientId", newJString(adClientId))
  add(path_578955, "accountId", newJString(accountId))
  add(query_578956, "fields", newJString(fields))
  result = call_578954.call(path_578955, query_578956, nil, nil, nil)

var adsensehostAccountsAdclientsGet* = Call_AdsensehostAccountsAdclientsGet_578941(
    name: "adsensehostAccountsAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}",
    validator: validate_AdsensehostAccountsAdclientsGet_578942,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdclientsGet_578943,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsUpdate_578976 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsUpdate_578978(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsUpdate_578977(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578979 = path.getOrDefault("adClientId")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "adClientId", valid_578979
  var valid_578980 = path.getOrDefault("accountId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "accountId", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("userIp")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "userIp", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("fields")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "fields", valid_578987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578989: Call_AdsensehostAccountsAdunitsUpdate_578976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_AdsensehostAccountsAdunitsUpdate_578976;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adsensehostAccountsAdunitsUpdate
  ## Update the supplied ad unit in the specified publisher AdSense account.
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
  ##             : Ad client which contains the ad unit.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  var body_578993 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "userIp", newJString(userIp))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "adClientId", newJString(adClientId))
  if body != nil:
    body_578993 = body
  add(path_578991, "accountId", newJString(accountId))
  add(query_578992, "fields", newJString(fields))
  result = call_578990.call(path_578991, query_578992, nil, nil, body_578993)

var adsensehostAccountsAdunitsUpdate* = Call_AdsensehostAccountsAdunitsUpdate_578976(
    name: "adsensehostAccountsAdunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsUpdate_578977,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsUpdate_578978,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsInsert_578994 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsInsert_578996(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsInsert_578995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client into which to insert the ad unit.
  ##   accountId: JString (required)
  ##            : Account which will contain the ad unit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578997 = path.getOrDefault("adClientId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "adClientId", valid_578997
  var valid_578998 = path.getOrDefault("accountId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "accountId", valid_578998
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
  var valid_578999 = query.getOrDefault("key")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "key", valid_578999
  var valid_579000 = query.getOrDefault("prettyPrint")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(true))
  if valid_579000 != nil:
    section.add "prettyPrint", valid_579000
  var valid_579001 = query.getOrDefault("oauth_token")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "oauth_token", valid_579001
  var valid_579002 = query.getOrDefault("alt")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = newJString("json"))
  if valid_579002 != nil:
    section.add "alt", valid_579002
  var valid_579003 = query.getOrDefault("userIp")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "userIp", valid_579003
  var valid_579004 = query.getOrDefault("quotaUser")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "quotaUser", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579007: Call_AdsensehostAccountsAdunitsInsert_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert the supplied ad unit into the specified publisher AdSense account.
  ## 
  let valid = call_579007.validator(path, query, header, formData, body)
  let scheme = call_579007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579007.url(scheme.get, call_579007.host, call_579007.base,
                         call_579007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579007, url, valid)

proc call*(call_579008: Call_AdsensehostAccountsAdunitsInsert_578994;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adsensehostAccountsAdunitsInsert
  ## Insert the supplied ad unit into the specified publisher AdSense account.
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
  ##             : Ad client into which to insert the ad unit.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account which will contain the ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579009 = newJObject()
  var query_579010 = newJObject()
  var body_579011 = newJObject()
  add(query_579010, "key", newJString(key))
  add(query_579010, "prettyPrint", newJBool(prettyPrint))
  add(query_579010, "oauth_token", newJString(oauthToken))
  add(query_579010, "alt", newJString(alt))
  add(query_579010, "userIp", newJString(userIp))
  add(query_579010, "quotaUser", newJString(quotaUser))
  add(path_579009, "adClientId", newJString(adClientId))
  if body != nil:
    body_579011 = body
  add(path_579009, "accountId", newJString(accountId))
  add(query_579010, "fields", newJString(fields))
  result = call_579008.call(path_579009, query_579010, nil, nil, body_579011)

var adsensehostAccountsAdunitsInsert* = Call_AdsensehostAccountsAdunitsInsert_578994(
    name: "adsensehostAccountsAdunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsInsert_578995,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsInsert_578996,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsList_578957 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsList_578959(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsList_578958(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list ad units.
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_578960 = path.getOrDefault("adClientId")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "adClientId", valid_578960
  var valid_578961 = path.getOrDefault("accountId")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "accountId", valid_578961
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
  var valid_578962 = query.getOrDefault("key")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "key", valid_578962
  var valid_578963 = query.getOrDefault("prettyPrint")
  valid_578963 = validateParameter(valid_578963, JBool, required = false,
                                 default = newJBool(true))
  if valid_578963 != nil:
    section.add "prettyPrint", valid_578963
  var valid_578964 = query.getOrDefault("oauth_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "oauth_token", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("userIp")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "userIp", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("pageToken")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "pageToken", valid_578968
  var valid_578969 = query.getOrDefault("includeInactive")
  valid_578969 = validateParameter(valid_578969, JBool, required = false, default = nil)
  if valid_578969 != nil:
    section.add "includeInactive", valid_578969
  var valid_578970 = query.getOrDefault("fields")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "fields", valid_578970
  var valid_578971 = query.getOrDefault("maxResults")
  valid_578971 = validateParameter(valid_578971, JInt, required = false, default = nil)
  if valid_578971 != nil:
    section.add "maxResults", valid_578971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578972: Call_AdsensehostAccountsAdunitsList_578957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified publisher's AdSense account.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_AdsensehostAccountsAdunitsList_578957;
          adClientId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          includeInactive: bool = false; fields: string = ""; maxResults: int = 0): Recallable =
  ## adsensehostAccountsAdunitsList
  ## List all ad units in the specified publisher's AdSense account.
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
  ##            : Account which contains the ad client.
  ##   includeInactive: bool
  ##                  : Whether to include inactive ad units. Default: true.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of ad units to include in the response, used for paging.
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "userIp", newJString(userIp))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(query_578975, "pageToken", newJString(pageToken))
  add(path_578974, "adClientId", newJString(adClientId))
  add(path_578974, "accountId", newJString(accountId))
  add(query_578975, "includeInactive", newJBool(includeInactive))
  add(query_578975, "fields", newJString(fields))
  add(query_578975, "maxResults", newJInt(maxResults))
  result = call_578973.call(path_578974, query_578975, nil, nil, nil)

var adsensehostAccountsAdunitsList* = Call_AdsensehostAccountsAdunitsList_578957(
    name: "adsensehostAccountsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsList_578958,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsList_578959,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsPatch_579012 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsPatch_579014(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsPatch_579013(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client which contains the ad unit.
  ##   accountId: JString (required)
  ##            : Account which contains the ad client.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579015 = path.getOrDefault("adClientId")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "adClientId", valid_579015
  var valid_579016 = path.getOrDefault("accountId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "accountId", valid_579016
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
  ##   adUnitId: JString (required)
  ##           : Ad unit to get.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("userIp")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "userIp", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  assert query != nil,
        "query argument is necessary due to required `adUnitId` field"
  var valid_579023 = query.getOrDefault("adUnitId")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "adUnitId", valid_579023
  var valid_579024 = query.getOrDefault("fields")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "fields", valid_579024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579026: Call_AdsensehostAccountsAdunitsPatch_579012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_AdsensehostAccountsAdunitsPatch_579012;
          adClientId: string; accountId: string; adUnitId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adsensehostAccountsAdunitsPatch
  ## Update the supplied ad unit in the specified publisher AdSense account. This method supports patch semantics.
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
  ##             : Ad client which contains the ad unit.
  ##   body: JObject
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   adUnitId: string (required)
  ##           : Ad unit to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  var body_579030 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "userIp", newJString(userIp))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(path_579028, "adClientId", newJString(adClientId))
  if body != nil:
    body_579030 = body
  add(path_579028, "accountId", newJString(accountId))
  add(query_579029, "adUnitId", newJString(adUnitId))
  add(query_579029, "fields", newJString(fields))
  result = call_579027.call(path_579028, query_579029, nil, nil, body_579030)

var adsensehostAccountsAdunitsPatch* = Call_AdsensehostAccountsAdunitsPatch_579012(
    name: "adsensehostAccountsAdunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits",
    validator: validate_AdsensehostAccountsAdunitsPatch_579013,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsPatch_579014,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGet_579031 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsGet_579033(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsGet_579032(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to get.
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579034 = path.getOrDefault("adClientId")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "adClientId", valid_579034
  var valid_579035 = path.getOrDefault("adUnitId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "adUnitId", valid_579035
  var valid_579036 = path.getOrDefault("accountId")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "accountId", valid_579036
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
  var valid_579037 = query.getOrDefault("key")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "key", valid_579037
  var valid_579038 = query.getOrDefault("prettyPrint")
  valid_579038 = validateParameter(valid_579038, JBool, required = false,
                                 default = newJBool(true))
  if valid_579038 != nil:
    section.add "prettyPrint", valid_579038
  var valid_579039 = query.getOrDefault("oauth_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "oauth_token", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("userIp")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "userIp", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("fields")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "fields", valid_579043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579044: Call_AdsensehostAccountsAdunitsGet_579031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified host ad unit in this AdSense account.
  ## 
  let valid = call_579044.validator(path, query, header, formData, body)
  let scheme = call_579044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579044.url(scheme.get, call_579044.host, call_579044.base,
                         call_579044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579044, url, valid)

proc call*(call_579045: Call_AdsensehostAccountsAdunitsGet_579031;
          adClientId: string; adUnitId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostAccountsAdunitsGet
  ## Get the specified host ad unit in this AdSense account.
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
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579046 = newJObject()
  var query_579047 = newJObject()
  add(query_579047, "key", newJString(key))
  add(query_579047, "prettyPrint", newJBool(prettyPrint))
  add(query_579047, "oauth_token", newJString(oauthToken))
  add(query_579047, "alt", newJString(alt))
  add(query_579047, "userIp", newJString(userIp))
  add(query_579047, "quotaUser", newJString(quotaUser))
  add(path_579046, "adClientId", newJString(adClientId))
  add(path_579046, "adUnitId", newJString(adUnitId))
  add(path_579046, "accountId", newJString(accountId))
  add(query_579047, "fields", newJString(fields))
  result = call_579045.call(path_579046, query_579047, nil, nil, nil)

var adsensehostAccountsAdunitsGet* = Call_AdsensehostAccountsAdunitsGet_579031(
    name: "adsensehostAccountsAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsGet_579032,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGet_579033,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsDelete_579048 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsDelete_579050(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsDelete_579049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: JString (required)
  ##           : Ad unit to delete.
  ##   accountId: JString (required)
  ##            : Account which contains the ad unit.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579051 = path.getOrDefault("adClientId")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "adClientId", valid_579051
  var valid_579052 = path.getOrDefault("adUnitId")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "adUnitId", valid_579052
  var valid_579053 = path.getOrDefault("accountId")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "accountId", valid_579053
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
  var valid_579054 = query.getOrDefault("key")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "key", valid_579054
  var valid_579055 = query.getOrDefault("prettyPrint")
  valid_579055 = validateParameter(valid_579055, JBool, required = false,
                                 default = newJBool(true))
  if valid_579055 != nil:
    section.add "prettyPrint", valid_579055
  var valid_579056 = query.getOrDefault("oauth_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "oauth_token", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("userIp")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "userIp", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("fields")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "fields", valid_579060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_AdsensehostAccountsAdunitsDelete_579048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the specified ad unit from the specified publisher AdSense account.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_AdsensehostAccountsAdunitsDelete_579048;
          adClientId: string; adUnitId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostAccountsAdunitsDelete
  ## Delete the specified ad unit from the specified publisher AdSense account.
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
  ##             : Ad client for which to get ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to delete.
  ##   accountId: string (required)
  ##            : Account which contains the ad unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "userIp", newJString(userIp))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(path_579063, "adClientId", newJString(adClientId))
  add(path_579063, "adUnitId", newJString(adUnitId))
  add(path_579063, "accountId", newJString(accountId))
  add(query_579064, "fields", newJString(fields))
  result = call_579062.call(path_579063, query_579064, nil, nil, nil)

var adsensehostAccountsAdunitsDelete* = Call_AdsensehostAccountsAdunitsDelete_579048(
    name: "adsensehostAccountsAdunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdsensehostAccountsAdunitsDelete_579049,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsDelete_579050,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsAdunitsGetAdCode_579065 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsAdunitsGetAdCode_579067(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsAdunitsGetAdCode_579066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
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
  var valid_579068 = path.getOrDefault("adClientId")
  valid_579068 = validateParameter(valid_579068, JString, required = true,
                                 default = nil)
  if valid_579068 != nil:
    section.add "adClientId", valid_579068
  var valid_579069 = path.getOrDefault("adUnitId")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "adUnitId", valid_579069
  var valid_579070 = path.getOrDefault("accountId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "accountId", valid_579070
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
  ##   hostCustomChannelId: JArray
  ##                      : Host custom channel to attach to the ad code.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("alt")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("json"))
  if valid_579074 != nil:
    section.add "alt", valid_579074
  var valid_579075 = query.getOrDefault("userIp")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "userIp", valid_579075
  var valid_579076 = query.getOrDefault("quotaUser")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "quotaUser", valid_579076
  var valid_579077 = query.getOrDefault("hostCustomChannelId")
  valid_579077 = validateParameter(valid_579077, JArray, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "hostCustomChannelId", valid_579077
  var valid_579078 = query.getOrDefault("fields")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "fields", valid_579078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579079: Call_AdsensehostAccountsAdunitsGetAdCode_579065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
  ## 
  let valid = call_579079.validator(path, query, header, formData, body)
  let scheme = call_579079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579079.url(scheme.get, call_579079.host, call_579079.base,
                         call_579079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579079, url, valid)

proc call*(call_579080: Call_AdsensehostAccountsAdunitsGetAdCode_579065;
          adClientId: string; adUnitId: string; accountId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          hostCustomChannelId: JsonNode = nil; fields: string = ""): Recallable =
  ## adsensehostAccountsAdunitsGetAdCode
  ## Get ad code for the specified ad unit, attaching the specified host custom channels.
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
  ##   hostCustomChannelId: JArray
  ##                      : Host custom channel to attach to the ad code.
  ##   adClientId: string (required)
  ##             : Ad client with contains the ad unit.
  ##   adUnitId: string (required)
  ##           : Ad unit to get the code for.
  ##   accountId: string (required)
  ##            : Account which contains the ad client.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579081 = newJObject()
  var query_579082 = newJObject()
  add(query_579082, "key", newJString(key))
  add(query_579082, "prettyPrint", newJBool(prettyPrint))
  add(query_579082, "oauth_token", newJString(oauthToken))
  add(query_579082, "alt", newJString(alt))
  add(query_579082, "userIp", newJString(userIp))
  add(query_579082, "quotaUser", newJString(quotaUser))
  if hostCustomChannelId != nil:
    query_579082.add "hostCustomChannelId", hostCustomChannelId
  add(path_579081, "adClientId", newJString(adClientId))
  add(path_579081, "adUnitId", newJString(adUnitId))
  add(path_579081, "accountId", newJString(accountId))
  add(query_579082, "fields", newJString(fields))
  result = call_579080.call(path_579081, query_579082, nil, nil, nil)

var adsensehostAccountsAdunitsGetAdCode* = Call_AdsensehostAccountsAdunitsGetAdCode_579065(
    name: "adsensehostAccountsAdunitsGetAdCode", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/adclients/{adClientId}/adunits/{adUnitId}/adcode",
    validator: validate_AdsensehostAccountsAdunitsGetAdCode_579066,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsAdunitsGetAdCode_579067,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAccountsReportsGenerate_579083 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAccountsReportsGenerate_579085(protocol: Scheme; host: string;
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

proc validate_AdsensehostAccountsReportsGenerate_579084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Hosted account upon which to report.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_579086 = path.getOrDefault("accountId")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "accountId", valid_579086
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
  ##   endDate: JString (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
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
  var valid_579087 = query.getOrDefault("key")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "key", valid_579087
  var valid_579088 = query.getOrDefault("prettyPrint")
  valid_579088 = validateParameter(valid_579088, JBool, required = false,
                                 default = newJBool(true))
  if valid_579088 != nil:
    section.add "prettyPrint", valid_579088
  var valid_579089 = query.getOrDefault("oauth_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "oauth_token", valid_579089
  var valid_579090 = query.getOrDefault("locale")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "locale", valid_579090
  var valid_579091 = query.getOrDefault("alt")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("json"))
  if valid_579091 != nil:
    section.add "alt", valid_579091
  var valid_579092 = query.getOrDefault("userIp")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "userIp", valid_579092
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579093 = query.getOrDefault("endDate")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "endDate", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("startIndex")
  valid_579095 = validateParameter(valid_579095, JInt, required = false, default = nil)
  if valid_579095 != nil:
    section.add "startIndex", valid_579095
  var valid_579096 = query.getOrDefault("filter")
  valid_579096 = validateParameter(valid_579096, JArray, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "filter", valid_579096
  var valid_579097 = query.getOrDefault("dimension")
  valid_579097 = validateParameter(valid_579097, JArray, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "dimension", valid_579097
  var valid_579098 = query.getOrDefault("metric")
  valid_579098 = validateParameter(valid_579098, JArray, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "metric", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  var valid_579100 = query.getOrDefault("startDate")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "startDate", valid_579100
  var valid_579101 = query.getOrDefault("maxResults")
  valid_579101 = validateParameter(valid_579101, JInt, required = false, default = nil)
  if valid_579101 != nil:
    section.add "maxResults", valid_579101
  var valid_579102 = query.getOrDefault("sort")
  valid_579102 = validateParameter(valid_579102, JArray, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "sort", valid_579102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579103: Call_AdsensehostAccountsReportsGenerate_579083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_AdsensehostAccountsReportsGenerate_579083;
          endDate: string; accountId: string; startDate: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; filter: JsonNode = nil; dimension: JsonNode = nil;
          metric: JsonNode = nil; fields: string = ""; maxResults: int = 0;
          sort: JsonNode = nil): Recallable =
  ## adsensehostAccountsReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
  ##   accountId: string (required)
  ##            : Hosted account upon which to report.
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
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "locale", newJString(locale))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "userIp", newJString(userIp))
  add(query_579106, "endDate", newJString(endDate))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(query_579106, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579106.add "filter", filter
  if dimension != nil:
    query_579106.add "dimension", dimension
  add(path_579105, "accountId", newJString(accountId))
  if metric != nil:
    query_579106.add "metric", metric
  add(query_579106, "fields", newJString(fields))
  add(query_579106, "startDate", newJString(startDate))
  add(query_579106, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579106.add "sort", sort
  result = call_579104.call(path_579105, query_579106, nil, nil, nil)

var adsensehostAccountsReportsGenerate* = Call_AdsensehostAccountsReportsGenerate_579083(
    name: "adsensehostAccountsReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}/reports",
    validator: validate_AdsensehostAccountsReportsGenerate_579084,
    base: "/adsensehost/v4.1", url: url_AdsensehostAccountsReportsGenerate_579085,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsList_579107 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAdclientsList_579109(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAdclientsList_579108(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host ad clients in this AdSense account.
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
  var valid_579110 = query.getOrDefault("key")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "key", valid_579110
  var valid_579111 = query.getOrDefault("prettyPrint")
  valid_579111 = validateParameter(valid_579111, JBool, required = false,
                                 default = newJBool(true))
  if valid_579111 != nil:
    section.add "prettyPrint", valid_579111
  var valid_579112 = query.getOrDefault("oauth_token")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "oauth_token", valid_579112
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
  var valid_579115 = query.getOrDefault("quotaUser")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "quotaUser", valid_579115
  var valid_579116 = query.getOrDefault("pageToken")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "pageToken", valid_579116
  var valid_579117 = query.getOrDefault("fields")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "fields", valid_579117
  var valid_579118 = query.getOrDefault("maxResults")
  valid_579118 = validateParameter(valid_579118, JInt, required = false, default = nil)
  if valid_579118 != nil:
    section.add "maxResults", valid_579118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579119: Call_AdsensehostAdclientsList_579107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host ad clients in this AdSense account.
  ## 
  let valid = call_579119.validator(path, query, header, formData, body)
  let scheme = call_579119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579119.url(scheme.get, call_579119.host, call_579119.base,
                         call_579119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579119, url, valid)

proc call*(call_579120: Call_AdsensehostAdclientsList_579107; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adsensehostAdclientsList
  ## List all host ad clients in this AdSense account.
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
  var query_579121 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "userIp", newJString(userIp))
  add(query_579121, "quotaUser", newJString(quotaUser))
  add(query_579121, "pageToken", newJString(pageToken))
  add(query_579121, "fields", newJString(fields))
  add(query_579121, "maxResults", newJInt(maxResults))
  result = call_579120.call(nil, query_579121, nil, nil, nil)

var adsensehostAdclientsList* = Call_AdsensehostAdclientsList_579107(
    name: "adsensehostAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdsensehostAdclientsList_579108,
    base: "/adsensehost/v4.1", url: url_AdsensehostAdclientsList_579109,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAdclientsGet_579122 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAdclientsGet_579124(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostAdclientsGet_579123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579125 = path.getOrDefault("adClientId")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "adClientId", valid_579125
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
  var valid_579126 = query.getOrDefault("key")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "key", valid_579126
  var valid_579127 = query.getOrDefault("prettyPrint")
  valid_579127 = validateParameter(valid_579127, JBool, required = false,
                                 default = newJBool(true))
  if valid_579127 != nil:
    section.add "prettyPrint", valid_579127
  var valid_579128 = query.getOrDefault("oauth_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "oauth_token", valid_579128
  var valid_579129 = query.getOrDefault("alt")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = newJString("json"))
  if valid_579129 != nil:
    section.add "alt", valid_579129
  var valid_579130 = query.getOrDefault("userIp")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "userIp", valid_579130
  var valid_579131 = query.getOrDefault("quotaUser")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "quotaUser", valid_579131
  var valid_579132 = query.getOrDefault("fields")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "fields", valid_579132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579133: Call_AdsensehostAdclientsGet_579122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about one of the ad clients in the Host AdSense account.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_AdsensehostAdclientsGet_579122; adClientId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adsensehostAdclientsGet
  ## Get information about one of the ad clients in the Host AdSense account.
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
  ##             : Ad client to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "userIp", newJString(userIp))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(path_579135, "adClientId", newJString(adClientId))
  add(query_579136, "fields", newJString(fields))
  result = call_579134.call(path_579135, query_579136, nil, nil, nil)

var adsensehostAdclientsGet* = Call_AdsensehostAdclientsGet_579122(
    name: "adsensehostAdclientsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}",
    validator: validate_AdsensehostAdclientsGet_579123, base: "/adsensehost/v4.1",
    url: url_AdsensehostAdclientsGet_579124, schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsUpdate_579154 = ref object of OpenApiRestCall_578355
proc url_AdsensehostCustomchannelsUpdate_579156(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsUpdate_579155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a custom channel in the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client in which the custom channel will be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579157 = path.getOrDefault("adClientId")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "adClientId", valid_579157
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
  var valid_579158 = query.getOrDefault("key")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "key", valid_579158
  var valid_579159 = query.getOrDefault("prettyPrint")
  valid_579159 = validateParameter(valid_579159, JBool, required = false,
                                 default = newJBool(true))
  if valid_579159 != nil:
    section.add "prettyPrint", valid_579159
  var valid_579160 = query.getOrDefault("oauth_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "oauth_token", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("userIp")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "userIp", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("fields")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "fields", valid_579164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579166: Call_AdsensehostCustomchannelsUpdate_579154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_AdsensehostCustomchannelsUpdate_579154;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adsensehostCustomchannelsUpdate
  ## Update a custom channel in the host AdSense account.
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
  ##             : Ad client in which the custom channel will be updated.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  var body_579170 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "userIp", newJString(userIp))
  add(query_579169, "quotaUser", newJString(quotaUser))
  add(path_579168, "adClientId", newJString(adClientId))
  if body != nil:
    body_579170 = body
  add(query_579169, "fields", newJString(fields))
  result = call_579167.call(path_579168, query_579169, nil, nil, body_579170)

var adsensehostCustomchannelsUpdate* = Call_AdsensehostCustomchannelsUpdate_579154(
    name: "adsensehostCustomchannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsUpdate_579155,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsUpdate_579156,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsInsert_579171 = ref object of OpenApiRestCall_578355
proc url_AdsensehostCustomchannelsInsert_579173(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsInsert_579172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new custom channel to the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to which the new custom channel will be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579174 = path.getOrDefault("adClientId")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "adClientId", valid_579174
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
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(true))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("alt")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("json"))
  if valid_579178 != nil:
    section.add "alt", valid_579178
  var valid_579179 = query.getOrDefault("userIp")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "userIp", valid_579179
  var valid_579180 = query.getOrDefault("quotaUser")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "quotaUser", valid_579180
  var valid_579181 = query.getOrDefault("fields")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "fields", valid_579181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579183: Call_AdsensehostCustomchannelsInsert_579171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new custom channel to the host AdSense account.
  ## 
  let valid = call_579183.validator(path, query, header, formData, body)
  let scheme = call_579183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579183.url(scheme.get, call_579183.host, call_579183.base,
                         call_579183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579183, url, valid)

proc call*(call_579184: Call_AdsensehostCustomchannelsInsert_579171;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adsensehostCustomchannelsInsert
  ## Add a new custom channel to the host AdSense account.
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
  ##             : Ad client to which the new custom channel will be added.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579185 = newJObject()
  var query_579186 = newJObject()
  var body_579187 = newJObject()
  add(query_579186, "key", newJString(key))
  add(query_579186, "prettyPrint", newJBool(prettyPrint))
  add(query_579186, "oauth_token", newJString(oauthToken))
  add(query_579186, "alt", newJString(alt))
  add(query_579186, "userIp", newJString(userIp))
  add(query_579186, "quotaUser", newJString(quotaUser))
  add(path_579185, "adClientId", newJString(adClientId))
  if body != nil:
    body_579187 = body
  add(query_579186, "fields", newJString(fields))
  result = call_579184.call(path_579185, query_579186, nil, nil, body_579187)

var adsensehostCustomchannelsInsert* = Call_AdsensehostCustomchannelsInsert_579171(
    name: "adsensehostCustomchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsInsert_579172,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsInsert_579173,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsList_579137 = ref object of OpenApiRestCall_578355
proc url_AdsensehostCustomchannelsList_579139(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsList_579138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host custom channels in this AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list custom channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579140 = path.getOrDefault("adClientId")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "adClientId", valid_579140
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
  var valid_579141 = query.getOrDefault("key")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "key", valid_579141
  var valid_579142 = query.getOrDefault("prettyPrint")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(true))
  if valid_579142 != nil:
    section.add "prettyPrint", valid_579142
  var valid_579143 = query.getOrDefault("oauth_token")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "oauth_token", valid_579143
  var valid_579144 = query.getOrDefault("alt")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("json"))
  if valid_579144 != nil:
    section.add "alt", valid_579144
  var valid_579145 = query.getOrDefault("userIp")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "userIp", valid_579145
  var valid_579146 = query.getOrDefault("quotaUser")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "quotaUser", valid_579146
  var valid_579147 = query.getOrDefault("pageToken")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "pageToken", valid_579147
  var valid_579148 = query.getOrDefault("fields")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "fields", valid_579148
  var valid_579149 = query.getOrDefault("maxResults")
  valid_579149 = validateParameter(valid_579149, JInt, required = false, default = nil)
  if valid_579149 != nil:
    section.add "maxResults", valid_579149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579150: Call_AdsensehostCustomchannelsList_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host custom channels in this AdSense account.
  ## 
  let valid = call_579150.validator(path, query, header, formData, body)
  let scheme = call_579150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579150.url(scheme.get, call_579150.host, call_579150.base,
                         call_579150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579150, url, valid)

proc call*(call_579151: Call_AdsensehostCustomchannelsList_579137;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adsensehostCustomchannelsList
  ## List all host custom channels in this AdSense account.
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
  var path_579152 = newJObject()
  var query_579153 = newJObject()
  add(query_579153, "key", newJString(key))
  add(query_579153, "prettyPrint", newJBool(prettyPrint))
  add(query_579153, "oauth_token", newJString(oauthToken))
  add(query_579153, "alt", newJString(alt))
  add(query_579153, "userIp", newJString(userIp))
  add(query_579153, "quotaUser", newJString(quotaUser))
  add(query_579153, "pageToken", newJString(pageToken))
  add(path_579152, "adClientId", newJString(adClientId))
  add(query_579153, "fields", newJString(fields))
  add(query_579153, "maxResults", newJInt(maxResults))
  result = call_579151.call(path_579152, query_579153, nil, nil, nil)

var adsensehostCustomchannelsList* = Call_AdsensehostCustomchannelsList_579137(
    name: "adsensehostCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsList_579138,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsList_579139,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsPatch_579188 = ref object of OpenApiRestCall_578355
proc url_AdsensehostCustomchannelsPatch_579190(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsPatch_579189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client in which the custom channel will be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579191 = path.getOrDefault("adClientId")
  valid_579191 = validateParameter(valid_579191, JString, required = true,
                                 default = nil)
  if valid_579191 != nil:
    section.add "adClientId", valid_579191
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
  ##   customChannelId: JString (required)
  ##                  : Custom channel to get.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579192 = query.getOrDefault("key")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "key", valid_579192
  var valid_579193 = query.getOrDefault("prettyPrint")
  valid_579193 = validateParameter(valid_579193, JBool, required = false,
                                 default = newJBool(true))
  if valid_579193 != nil:
    section.add "prettyPrint", valid_579193
  var valid_579194 = query.getOrDefault("oauth_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "oauth_token", valid_579194
  var valid_579195 = query.getOrDefault("alt")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = newJString("json"))
  if valid_579195 != nil:
    section.add "alt", valid_579195
  var valid_579196 = query.getOrDefault("userIp")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "userIp", valid_579196
  var valid_579197 = query.getOrDefault("quotaUser")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "quotaUser", valid_579197
  assert query != nil,
        "query argument is necessary due to required `customChannelId` field"
  var valid_579198 = query.getOrDefault("customChannelId")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "customChannelId", valid_579198
  var valid_579199 = query.getOrDefault("fields")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "fields", valid_579199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579201: Call_AdsensehostCustomchannelsPatch_579188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_AdsensehostCustomchannelsPatch_579188;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adsensehostCustomchannelsPatch
  ## Update a custom channel in the host AdSense account. This method supports patch semantics.
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
  ##             : Ad client in which the custom channel will be updated.
  ##   body: JObject
  ##   customChannelId: string (required)
  ##                  : Custom channel to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "userIp", newJString(userIp))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(path_579203, "adClientId", newJString(adClientId))
  if body != nil:
    body_579205 = body
  add(query_579204, "customChannelId", newJString(customChannelId))
  add(query_579204, "fields", newJString(fields))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var adsensehostCustomchannelsPatch* = Call_AdsensehostCustomchannelsPatch_579188(
    name: "adsensehostCustomchannelsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdsensehostCustomchannelsPatch_579189,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsPatch_579190,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsGet_579206 = ref object of OpenApiRestCall_578355
proc url_AdsensehostCustomchannelsGet_579208(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsGet_579207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client from which to get the custom channel.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579209 = path.getOrDefault("adClientId")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "adClientId", valid_579209
  var valid_579210 = path.getOrDefault("customChannelId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "customChannelId", valid_579210
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
  var valid_579211 = query.getOrDefault("key")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "key", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("alt")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = newJString("json"))
  if valid_579214 != nil:
    section.add "alt", valid_579214
  var valid_579215 = query.getOrDefault("userIp")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "userIp", valid_579215
  var valid_579216 = query.getOrDefault("quotaUser")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "quotaUser", valid_579216
  var valid_579217 = query.getOrDefault("fields")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "fields", valid_579217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579218: Call_AdsensehostCustomchannelsGet_579206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a specific custom channel from the host AdSense account.
  ## 
  let valid = call_579218.validator(path, query, header, formData, body)
  let scheme = call_579218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579218.url(scheme.get, call_579218.host, call_579218.base,
                         call_579218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579218, url, valid)

proc call*(call_579219: Call_AdsensehostCustomchannelsGet_579206;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostCustomchannelsGet
  ## Get a specific custom channel from the host AdSense account.
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
  ##             : Ad client from which to get the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579220 = newJObject()
  var query_579221 = newJObject()
  add(query_579221, "key", newJString(key))
  add(query_579221, "prettyPrint", newJBool(prettyPrint))
  add(query_579221, "oauth_token", newJString(oauthToken))
  add(query_579221, "alt", newJString(alt))
  add(query_579221, "userIp", newJString(userIp))
  add(query_579221, "quotaUser", newJString(quotaUser))
  add(path_579220, "adClientId", newJString(adClientId))
  add(path_579220, "customChannelId", newJString(customChannelId))
  add(query_579221, "fields", newJString(fields))
  result = call_579219.call(path_579220, query_579221, nil, nil, nil)

var adsensehostCustomchannelsGet* = Call_AdsensehostCustomchannelsGet_579206(
    name: "adsensehostCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsGet_579207,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsGet_579208,
    schemes: {Scheme.Https})
type
  Call_AdsensehostCustomchannelsDelete_579222 = ref object of OpenApiRestCall_578355
proc url_AdsensehostCustomchannelsDelete_579224(protocol: Scheme; host: string;
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

proc validate_AdsensehostCustomchannelsDelete_579223(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client from which to delete the custom channel.
  ##   customChannelId: JString (required)
  ##                  : Custom channel to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579225 = path.getOrDefault("adClientId")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "adClientId", valid_579225
  var valid_579226 = path.getOrDefault("customChannelId")
  valid_579226 = validateParameter(valid_579226, JString, required = true,
                                 default = nil)
  if valid_579226 != nil:
    section.add "customChannelId", valid_579226
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
  var valid_579227 = query.getOrDefault("key")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "key", valid_579227
  var valid_579228 = query.getOrDefault("prettyPrint")
  valid_579228 = validateParameter(valid_579228, JBool, required = false,
                                 default = newJBool(true))
  if valid_579228 != nil:
    section.add "prettyPrint", valid_579228
  var valid_579229 = query.getOrDefault("oauth_token")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "oauth_token", valid_579229
  var valid_579230 = query.getOrDefault("alt")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = newJString("json"))
  if valid_579230 != nil:
    section.add "alt", valid_579230
  var valid_579231 = query.getOrDefault("userIp")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "userIp", valid_579231
  var valid_579232 = query.getOrDefault("quotaUser")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "quotaUser", valid_579232
  var valid_579233 = query.getOrDefault("fields")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "fields", valid_579233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579234: Call_AdsensehostCustomchannelsDelete_579222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a specific custom channel from the host AdSense account.
  ## 
  let valid = call_579234.validator(path, query, header, formData, body)
  let scheme = call_579234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579234.url(scheme.get, call_579234.host, call_579234.base,
                         call_579234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579234, url, valid)

proc call*(call_579235: Call_AdsensehostCustomchannelsDelete_579222;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostCustomchannelsDelete
  ## Delete a specific custom channel from the host AdSense account.
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
  ##             : Ad client from which to delete the custom channel.
  ##   customChannelId: string (required)
  ##                  : Custom channel to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579236 = newJObject()
  var query_579237 = newJObject()
  add(query_579237, "key", newJString(key))
  add(query_579237, "prettyPrint", newJBool(prettyPrint))
  add(query_579237, "oauth_token", newJString(oauthToken))
  add(query_579237, "alt", newJString(alt))
  add(query_579237, "userIp", newJString(userIp))
  add(query_579237, "quotaUser", newJString(quotaUser))
  add(path_579236, "adClientId", newJString(adClientId))
  add(path_579236, "customChannelId", newJString(customChannelId))
  add(query_579237, "fields", newJString(fields))
  result = call_579235.call(path_579236, query_579237, nil, nil, nil)

var adsensehostCustomchannelsDelete* = Call_AdsensehostCustomchannelsDelete_579222(
    name: "adsensehostCustomchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdsensehostCustomchannelsDelete_579223,
    base: "/adsensehost/v4.1", url: url_AdsensehostCustomchannelsDelete_579224,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsInsert_579255 = ref object of OpenApiRestCall_578355
proc url_AdsensehostUrlchannelsInsert_579257(protocol: Scheme; host: string;
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

proc validate_AdsensehostUrlchannelsInsert_579256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new URL channel to the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client to which the new URL channel will be added.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579258 = path.getOrDefault("adClientId")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "adClientId", valid_579258
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
  var valid_579259 = query.getOrDefault("key")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "key", valid_579259
  var valid_579260 = query.getOrDefault("prettyPrint")
  valid_579260 = validateParameter(valid_579260, JBool, required = false,
                                 default = newJBool(true))
  if valid_579260 != nil:
    section.add "prettyPrint", valid_579260
  var valid_579261 = query.getOrDefault("oauth_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "oauth_token", valid_579261
  var valid_579262 = query.getOrDefault("alt")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = newJString("json"))
  if valid_579262 != nil:
    section.add "alt", valid_579262
  var valid_579263 = query.getOrDefault("userIp")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "userIp", valid_579263
  var valid_579264 = query.getOrDefault("quotaUser")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "quotaUser", valid_579264
  var valid_579265 = query.getOrDefault("fields")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "fields", valid_579265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579267: Call_AdsensehostUrlchannelsInsert_579255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new URL channel to the host AdSense account.
  ## 
  let valid = call_579267.validator(path, query, header, formData, body)
  let scheme = call_579267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579267.url(scheme.get, call_579267.host, call_579267.base,
                         call_579267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579267, url, valid)

proc call*(call_579268: Call_AdsensehostUrlchannelsInsert_579255;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## adsensehostUrlchannelsInsert
  ## Add a new URL channel to the host AdSense account.
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
  ##             : Ad client to which the new URL channel will be added.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579269 = newJObject()
  var query_579270 = newJObject()
  var body_579271 = newJObject()
  add(query_579270, "key", newJString(key))
  add(query_579270, "prettyPrint", newJBool(prettyPrint))
  add(query_579270, "oauth_token", newJString(oauthToken))
  add(query_579270, "alt", newJString(alt))
  add(query_579270, "userIp", newJString(userIp))
  add(query_579270, "quotaUser", newJString(quotaUser))
  add(path_579269, "adClientId", newJString(adClientId))
  if body != nil:
    body_579271 = body
  add(query_579270, "fields", newJString(fields))
  result = call_579268.call(path_579269, query_579270, nil, nil, body_579271)

var adsensehostUrlchannelsInsert* = Call_AdsensehostUrlchannelsInsert_579255(
    name: "adsensehostUrlchannelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsInsert_579256,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsInsert_579257,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsList_579238 = ref object of OpenApiRestCall_578355
proc url_AdsensehostUrlchannelsList_579240(protocol: Scheme; host: string;
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

proc validate_AdsensehostUrlchannelsList_579239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all host URL channels in the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client for which to list URL channels.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579241 = path.getOrDefault("adClientId")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "adClientId", valid_579241
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
  var valid_579242 = query.getOrDefault("key")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "key", valid_579242
  var valid_579243 = query.getOrDefault("prettyPrint")
  valid_579243 = validateParameter(valid_579243, JBool, required = false,
                                 default = newJBool(true))
  if valid_579243 != nil:
    section.add "prettyPrint", valid_579243
  var valid_579244 = query.getOrDefault("oauth_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "oauth_token", valid_579244
  var valid_579245 = query.getOrDefault("alt")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = newJString("json"))
  if valid_579245 != nil:
    section.add "alt", valid_579245
  var valid_579246 = query.getOrDefault("userIp")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "userIp", valid_579246
  var valid_579247 = query.getOrDefault("quotaUser")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "quotaUser", valid_579247
  var valid_579248 = query.getOrDefault("pageToken")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "pageToken", valid_579248
  var valid_579249 = query.getOrDefault("fields")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "fields", valid_579249
  var valid_579250 = query.getOrDefault("maxResults")
  valid_579250 = validateParameter(valid_579250, JInt, required = false, default = nil)
  if valid_579250 != nil:
    section.add "maxResults", valid_579250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579251: Call_AdsensehostUrlchannelsList_579238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all host URL channels in the host AdSense account.
  ## 
  let valid = call_579251.validator(path, query, header, formData, body)
  let scheme = call_579251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579251.url(scheme.get, call_579251.host, call_579251.base,
                         call_579251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579251, url, valid)

proc call*(call_579252: Call_AdsensehostUrlchannelsList_579238; adClientId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adsensehostUrlchannelsList
  ## List all host URL channels in the host AdSense account.
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
  var path_579253 = newJObject()
  var query_579254 = newJObject()
  add(query_579254, "key", newJString(key))
  add(query_579254, "prettyPrint", newJBool(prettyPrint))
  add(query_579254, "oauth_token", newJString(oauthToken))
  add(query_579254, "alt", newJString(alt))
  add(query_579254, "userIp", newJString(userIp))
  add(query_579254, "quotaUser", newJString(quotaUser))
  add(query_579254, "pageToken", newJString(pageToken))
  add(path_579253, "adClientId", newJString(adClientId))
  add(query_579254, "fields", newJString(fields))
  add(query_579254, "maxResults", newJInt(maxResults))
  result = call_579252.call(path_579253, query_579254, nil, nil, nil)

var adsensehostUrlchannelsList* = Call_AdsensehostUrlchannelsList_579238(
    name: "adsensehostUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdsensehostUrlchannelsList_579239,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsList_579240,
    schemes: {Scheme.Https})
type
  Call_AdsensehostUrlchannelsDelete_579272 = ref object of OpenApiRestCall_578355
proc url_AdsensehostUrlchannelsDelete_579274(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "adClientId" in path, "`adClientId` is a required path parameter"
  assert "urlChannelId" in path, "`urlChannelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/adclients/"),
               (kind: VariableSegment, value: "adClientId"),
               (kind: ConstantSegment, value: "/urlchannels/"),
               (kind: VariableSegment, value: "urlChannelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdsensehostUrlchannelsDelete_579273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a URL channel from the host AdSense account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   adClientId: JString (required)
  ##             : Ad client from which to delete the URL channel.
  ##   urlChannelId: JString (required)
  ##               : URL channel to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `adClientId` field"
  var valid_579275 = path.getOrDefault("adClientId")
  valid_579275 = validateParameter(valid_579275, JString, required = true,
                                 default = nil)
  if valid_579275 != nil:
    section.add "adClientId", valid_579275
  var valid_579276 = path.getOrDefault("urlChannelId")
  valid_579276 = validateParameter(valid_579276, JString, required = true,
                                 default = nil)
  if valid_579276 != nil:
    section.add "urlChannelId", valid_579276
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
  var valid_579277 = query.getOrDefault("key")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "key", valid_579277
  var valid_579278 = query.getOrDefault("prettyPrint")
  valid_579278 = validateParameter(valid_579278, JBool, required = false,
                                 default = newJBool(true))
  if valid_579278 != nil:
    section.add "prettyPrint", valid_579278
  var valid_579279 = query.getOrDefault("oauth_token")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "oauth_token", valid_579279
  var valid_579280 = query.getOrDefault("alt")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("json"))
  if valid_579280 != nil:
    section.add "alt", valid_579280
  var valid_579281 = query.getOrDefault("userIp")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "userIp", valid_579281
  var valid_579282 = query.getOrDefault("quotaUser")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "quotaUser", valid_579282
  var valid_579283 = query.getOrDefault("fields")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "fields", valid_579283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579284: Call_AdsensehostUrlchannelsDelete_579272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a URL channel from the host AdSense account.
  ## 
  let valid = call_579284.validator(path, query, header, formData, body)
  let scheme = call_579284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579284.url(scheme.get, call_579284.host, call_579284.base,
                         call_579284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579284, url, valid)

proc call*(call_579285: Call_AdsensehostUrlchannelsDelete_579272;
          adClientId: string; urlChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostUrlchannelsDelete
  ## Delete a URL channel from the host AdSense account.
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
  ##             : Ad client from which to delete the URL channel.
  ##   urlChannelId: string (required)
  ##               : URL channel to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579286 = newJObject()
  var query_579287 = newJObject()
  add(query_579287, "key", newJString(key))
  add(query_579287, "prettyPrint", newJBool(prettyPrint))
  add(query_579287, "oauth_token", newJString(oauthToken))
  add(query_579287, "alt", newJString(alt))
  add(query_579287, "userIp", newJString(userIp))
  add(query_579287, "quotaUser", newJString(quotaUser))
  add(path_579286, "adClientId", newJString(adClientId))
  add(path_579286, "urlChannelId", newJString(urlChannelId))
  add(query_579287, "fields", newJString(fields))
  result = call_579285.call(path_579286, query_579287, nil, nil, nil)

var adsensehostUrlchannelsDelete* = Call_AdsensehostUrlchannelsDelete_579272(
    name: "adsensehostUrlchannelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/urlchannels/{urlChannelId}",
    validator: validate_AdsensehostUrlchannelsDelete_579273,
    base: "/adsensehost/v4.1", url: url_AdsensehostUrlchannelsDelete_579274,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsStart_579288 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAssociationsessionsStart_579290(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsStart_579289(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an association session for initiating an association with an AdSense user.
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
  ##   productCode: JArray (required)
  ##              : Products to associate with the user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userLocale: JString
  ##             : The preferred locale of the user.
  ##   websiteUrl: JString (required)
  ##             : The URL of the user's hosted website.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   websiteLocale: JString
  ##                : The locale of the user's hosted website.
  section = newJObject()
  var valid_579291 = query.getOrDefault("key")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "key", valid_579291
  var valid_579292 = query.getOrDefault("prettyPrint")
  valid_579292 = validateParameter(valid_579292, JBool, required = false,
                                 default = newJBool(true))
  if valid_579292 != nil:
    section.add "prettyPrint", valid_579292
  var valid_579293 = query.getOrDefault("oauth_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "oauth_token", valid_579293
  assert query != nil,
        "query argument is necessary due to required `productCode` field"
  var valid_579294 = query.getOrDefault("productCode")
  valid_579294 = validateParameter(valid_579294, JArray, required = true, default = nil)
  if valid_579294 != nil:
    section.add "productCode", valid_579294
  var valid_579295 = query.getOrDefault("alt")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = newJString("json"))
  if valid_579295 != nil:
    section.add "alt", valid_579295
  var valid_579296 = query.getOrDefault("userIp")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "userIp", valid_579296
  var valid_579297 = query.getOrDefault("quotaUser")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "quotaUser", valid_579297
  var valid_579298 = query.getOrDefault("userLocale")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "userLocale", valid_579298
  var valid_579299 = query.getOrDefault("websiteUrl")
  valid_579299 = validateParameter(valid_579299, JString, required = true,
                                 default = nil)
  if valid_579299 != nil:
    section.add "websiteUrl", valid_579299
  var valid_579300 = query.getOrDefault("fields")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "fields", valid_579300
  var valid_579301 = query.getOrDefault("websiteLocale")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "websiteLocale", valid_579301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579302: Call_AdsensehostAssociationsessionsStart_579288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an association session for initiating an association with an AdSense user.
  ## 
  let valid = call_579302.validator(path, query, header, formData, body)
  let scheme = call_579302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579302.url(scheme.get, call_579302.host, call_579302.base,
                         call_579302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579302, url, valid)

proc call*(call_579303: Call_AdsensehostAssociationsessionsStart_579288;
          productCode: JsonNode; websiteUrl: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; userLocale: string = "";
          fields: string = ""; websiteLocale: string = ""): Recallable =
  ## adsensehostAssociationsessionsStart
  ## Create an association session for initiating an association with an AdSense user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   productCode: JArray (required)
  ##              : Products to associate with the user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userLocale: string
  ##             : The preferred locale of the user.
  ##   websiteUrl: string (required)
  ##             : The URL of the user's hosted website.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   websiteLocale: string
  ##                : The locale of the user's hosted website.
  var query_579304 = newJObject()
  add(query_579304, "key", newJString(key))
  add(query_579304, "prettyPrint", newJBool(prettyPrint))
  add(query_579304, "oauth_token", newJString(oauthToken))
  if productCode != nil:
    query_579304.add "productCode", productCode
  add(query_579304, "alt", newJString(alt))
  add(query_579304, "userIp", newJString(userIp))
  add(query_579304, "quotaUser", newJString(quotaUser))
  add(query_579304, "userLocale", newJString(userLocale))
  add(query_579304, "websiteUrl", newJString(websiteUrl))
  add(query_579304, "fields", newJString(fields))
  add(query_579304, "websiteLocale", newJString(websiteLocale))
  result = call_579303.call(nil, query_579304, nil, nil, nil)

var adsensehostAssociationsessionsStart* = Call_AdsensehostAssociationsessionsStart_579288(
    name: "adsensehostAssociationsessionsStart", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/start",
    validator: validate_AdsensehostAssociationsessionsStart_579289,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsStart_579290,
    schemes: {Scheme.Https})
type
  Call_AdsensehostAssociationsessionsVerify_579305 = ref object of OpenApiRestCall_578355
proc url_AdsensehostAssociationsessionsVerify_579307(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostAssociationsessionsVerify_579306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify an association session after the association callback returns from AdSense signup.
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
  ##   token: JString (required)
  ##        : The token returned to the association callback URL.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579308 = query.getOrDefault("key")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "key", valid_579308
  var valid_579309 = query.getOrDefault("prettyPrint")
  valid_579309 = validateParameter(valid_579309, JBool, required = false,
                                 default = newJBool(true))
  if valid_579309 != nil:
    section.add "prettyPrint", valid_579309
  var valid_579310 = query.getOrDefault("oauth_token")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "oauth_token", valid_579310
  var valid_579311 = query.getOrDefault("alt")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = newJString("json"))
  if valid_579311 != nil:
    section.add "alt", valid_579311
  var valid_579312 = query.getOrDefault("userIp")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "userIp", valid_579312
  var valid_579313 = query.getOrDefault("quotaUser")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "quotaUser", valid_579313
  assert query != nil, "query argument is necessary due to required `token` field"
  var valid_579314 = query.getOrDefault("token")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "token", valid_579314
  var valid_579315 = query.getOrDefault("fields")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "fields", valid_579315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579316: Call_AdsensehostAssociationsessionsVerify_579305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify an association session after the association callback returns from AdSense signup.
  ## 
  let valid = call_579316.validator(path, query, header, formData, body)
  let scheme = call_579316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579316.url(scheme.get, call_579316.host, call_579316.base,
                         call_579316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579316, url, valid)

proc call*(call_579317: Call_AdsensehostAssociationsessionsVerify_579305;
          token: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adsensehostAssociationsessionsVerify
  ## Verify an association session after the association callback returns from AdSense signup.
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
  ##   token: string (required)
  ##        : The token returned to the association callback URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579318 = newJObject()
  add(query_579318, "key", newJString(key))
  add(query_579318, "prettyPrint", newJBool(prettyPrint))
  add(query_579318, "oauth_token", newJString(oauthToken))
  add(query_579318, "alt", newJString(alt))
  add(query_579318, "userIp", newJString(userIp))
  add(query_579318, "quotaUser", newJString(quotaUser))
  add(query_579318, "token", newJString(token))
  add(query_579318, "fields", newJString(fields))
  result = call_579317.call(nil, query_579318, nil, nil, nil)

var adsensehostAssociationsessionsVerify* = Call_AdsensehostAssociationsessionsVerify_579305(
    name: "adsensehostAssociationsessionsVerify", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/associationsessions/verify",
    validator: validate_AdsensehostAssociationsessionsVerify_579306,
    base: "/adsensehost/v4.1", url: url_AdsensehostAssociationsessionsVerify_579307,
    schemes: {Scheme.Https})
type
  Call_AdsensehostReportsGenerate_579319 = ref object of OpenApiRestCall_578355
proc url_AdsensehostReportsGenerate_579321(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdsensehostReportsGenerate_579320(path: JsonNode; query: JsonNode;
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
  var valid_579322 = query.getOrDefault("key")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "key", valid_579322
  var valid_579323 = query.getOrDefault("prettyPrint")
  valid_579323 = validateParameter(valid_579323, JBool, required = false,
                                 default = newJBool(true))
  if valid_579323 != nil:
    section.add "prettyPrint", valid_579323
  var valid_579324 = query.getOrDefault("oauth_token")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "oauth_token", valid_579324
  var valid_579325 = query.getOrDefault("locale")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "locale", valid_579325
  var valid_579326 = query.getOrDefault("alt")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = newJString("json"))
  if valid_579326 != nil:
    section.add "alt", valid_579326
  var valid_579327 = query.getOrDefault("userIp")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "userIp", valid_579327
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579328 = query.getOrDefault("endDate")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "endDate", valid_579328
  var valid_579329 = query.getOrDefault("quotaUser")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "quotaUser", valid_579329
  var valid_579330 = query.getOrDefault("startIndex")
  valid_579330 = validateParameter(valid_579330, JInt, required = false, default = nil)
  if valid_579330 != nil:
    section.add "startIndex", valid_579330
  var valid_579331 = query.getOrDefault("filter")
  valid_579331 = validateParameter(valid_579331, JArray, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "filter", valid_579331
  var valid_579332 = query.getOrDefault("dimension")
  valid_579332 = validateParameter(valid_579332, JArray, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "dimension", valid_579332
  var valid_579333 = query.getOrDefault("metric")
  valid_579333 = validateParameter(valid_579333, JArray, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "metric", valid_579333
  var valid_579334 = query.getOrDefault("fields")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "fields", valid_579334
  var valid_579335 = query.getOrDefault("startDate")
  valid_579335 = validateParameter(valid_579335, JString, required = true,
                                 default = nil)
  if valid_579335 != nil:
    section.add "startDate", valid_579335
  var valid_579336 = query.getOrDefault("maxResults")
  valid_579336 = validateParameter(valid_579336, JInt, required = false, default = nil)
  if valid_579336 != nil:
    section.add "maxResults", valid_579336
  var valid_579337 = query.getOrDefault("sort")
  valid_579337 = validateParameter(valid_579337, JArray, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "sort", valid_579337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579338: Call_AdsensehostReportsGenerate_579319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579338.validator(path, query, header, formData, body)
  let scheme = call_579338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579338.url(scheme.get, call_579338.host, call_579338.base,
                         call_579338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579338, url, valid)

proc call*(call_579339: Call_AdsensehostReportsGenerate_579319; endDate: string;
          startDate: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          filter: JsonNode = nil; dimension: JsonNode = nil; metric: JsonNode = nil;
          fields: string = ""; maxResults: int = 0; sort: JsonNode = nil): Recallable =
  ## adsensehostReportsGenerate
  ## Generate an AdSense report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  ##   endDate: string (required)
  ##          : End of the date range to report on in "YYYY-MM-DD" format, inclusive.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first row of report data to return.
  ##   filter: JArray
  ##         : Filters to be run on the report.
  ##   dimension: JArray
  ##            : Dimensions to base the report on.
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
  var query_579340 = newJObject()
  add(query_579340, "key", newJString(key))
  add(query_579340, "prettyPrint", newJBool(prettyPrint))
  add(query_579340, "oauth_token", newJString(oauthToken))
  add(query_579340, "locale", newJString(locale))
  add(query_579340, "alt", newJString(alt))
  add(query_579340, "userIp", newJString(userIp))
  add(query_579340, "endDate", newJString(endDate))
  add(query_579340, "quotaUser", newJString(quotaUser))
  add(query_579340, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579340.add "filter", filter
  if dimension != nil:
    query_579340.add "dimension", dimension
  if metric != nil:
    query_579340.add "metric", metric
  add(query_579340, "fields", newJString(fields))
  add(query_579340, "startDate", newJString(startDate))
  add(query_579340, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579340.add "sort", sort
  result = call_579339.call(nil, query_579340, nil, nil, nil)

var adsensehostReportsGenerate* = Call_AdsensehostReportsGenerate_579319(
    name: "adsensehostReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdsensehostReportsGenerate_579320,
    base: "/adsensehost/v4.1", url: url_AdsensehostReportsGenerate_579321,
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
