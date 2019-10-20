
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
  gcpServiceName = "adexchangeseller"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdexchangesellerAccountsGet_578626 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAccountsGet_578628(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAccountsGet_578627(path: JsonNode; query: JsonNode;
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
  var valid_578754 = path.getOrDefault("accountId")
  valid_578754 = validateParameter(valid_578754, JString, required = true,
                                 default = nil)
  if valid_578754 != nil:
    section.add "accountId", valid_578754
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
  var valid_578755 = query.getOrDefault("key")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "key", valid_578755
  var valid_578769 = query.getOrDefault("prettyPrint")
  valid_578769 = validateParameter(valid_578769, JBool, required = false,
                                 default = newJBool(true))
  if valid_578769 != nil:
    section.add "prettyPrint", valid_578769
  var valid_578770 = query.getOrDefault("oauth_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "oauth_token", valid_578770
  var valid_578771 = query.getOrDefault("alt")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = newJString("json"))
  if valid_578771 != nil:
    section.add "alt", valid_578771
  var valid_578772 = query.getOrDefault("userIp")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "userIp", valid_578772
  var valid_578773 = query.getOrDefault("quotaUser")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "quotaUser", valid_578773
  var valid_578774 = query.getOrDefault("fields")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "fields", valid_578774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578797: Call_AdexchangesellerAccountsGet_578626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange account.
  ## 
  let valid = call_578797.validator(path, query, header, formData, body)
  let scheme = call_578797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578797.url(scheme.get, call_578797.host, call_578797.base,
                         call_578797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578797, url, valid)

proc call*(call_578868: Call_AdexchangesellerAccountsGet_578626; accountId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerAccountsGet
  ## Get information about the selected Ad Exchange account.
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
  ##            : Account to get information about. Tip: 'myaccount' is a valid ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578869 = newJObject()
  var query_578871 = newJObject()
  add(query_578871, "key", newJString(key))
  add(query_578871, "prettyPrint", newJBool(prettyPrint))
  add(query_578871, "oauth_token", newJString(oauthToken))
  add(query_578871, "alt", newJString(alt))
  add(query_578871, "userIp", newJString(userIp))
  add(query_578871, "quotaUser", newJString(quotaUser))
  add(path_578869, "accountId", newJString(accountId))
  add(query_578871, "fields", newJString(fields))
  result = call_578868.call(path_578869, query_578871, nil, nil, nil)

var adexchangesellerAccountsGet* = Call_AdexchangesellerAccountsGet_578626(
    name: "adexchangesellerAccountsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/accounts/{accountId}",
    validator: validate_AdexchangesellerAccountsGet_578627,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAccountsGet_578628,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdclientsList_578910 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdclientsList_578912(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAdclientsList_578911(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all ad clients in this Ad Exchange account.
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
  var valid_578919 = query.getOrDefault("pageToken")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "pageToken", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("maxResults")
  valid_578921 = validateParameter(valid_578921, JInt, required = false, default = nil)
  if valid_578921 != nil:
    section.add "maxResults", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_AdexchangesellerAdclientsList_578910; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad clients in this Ad Exchange account.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_AdexchangesellerAdclientsList_578910;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAdclientsList
  ## List all ad clients in this Ad Exchange account.
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
  var query_578924 = newJObject()
  add(query_578924, "key", newJString(key))
  add(query_578924, "prettyPrint", newJBool(prettyPrint))
  add(query_578924, "oauth_token", newJString(oauthToken))
  add(query_578924, "alt", newJString(alt))
  add(query_578924, "userIp", newJString(userIp))
  add(query_578924, "quotaUser", newJString(quotaUser))
  add(query_578924, "pageToken", newJString(pageToken))
  add(query_578924, "fields", newJString(fields))
  add(query_578924, "maxResults", newJInt(maxResults))
  result = call_578923.call(nil, query_578924, nil, nil, nil)

var adexchangesellerAdclientsList* = Call_AdexchangesellerAdclientsList_578910(
    name: "adexchangesellerAdclientsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients",
    validator: validate_AdexchangesellerAdclientsList_578911,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdclientsList_578912,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsList_578925 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdunitsList_578927(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAdunitsList_578926(path: JsonNode; query: JsonNode;
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
  var valid_578928 = path.getOrDefault("adClientId")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "adClientId", valid_578928
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
  var valid_578929 = query.getOrDefault("key")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "key", valid_578929
  var valid_578930 = query.getOrDefault("prettyPrint")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(true))
  if valid_578930 != nil:
    section.add "prettyPrint", valid_578930
  var valid_578931 = query.getOrDefault("oauth_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "oauth_token", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("userIp")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "userIp", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("pageToken")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "pageToken", valid_578935
  var valid_578936 = query.getOrDefault("includeInactive")
  valid_578936 = validateParameter(valid_578936, JBool, required = false, default = nil)
  if valid_578936 != nil:
    section.add "includeInactive", valid_578936
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

proc call*(call_578939: Call_AdexchangesellerAdunitsList_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all ad units in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_AdexchangesellerAdunitsList_578925;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; includeInactive: bool = false;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAdunitsList
  ## List all ad units in the specified ad client for this Ad Exchange account.
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
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "userIp", newJString(userIp))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(query_578942, "pageToken", newJString(pageToken))
  add(path_578941, "adClientId", newJString(adClientId))
  add(query_578942, "includeInactive", newJBool(includeInactive))
  add(query_578942, "fields", newJString(fields))
  add(query_578942, "maxResults", newJInt(maxResults))
  result = call_578940.call(path_578941, query_578942, nil, nil, nil)

var adexchangesellerAdunitsList* = Call_AdexchangesellerAdunitsList_578925(
    name: "adexchangesellerAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/adunits",
    validator: validate_AdexchangesellerAdunitsList_578926,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdunitsList_578927,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsGet_578943 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdunitsGet_578945(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerAdunitsGet_578944(path: JsonNode; query: JsonNode;
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
  var valid_578946 = path.getOrDefault("adClientId")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "adClientId", valid_578946
  var valid_578947 = path.getOrDefault("adUnitId")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "adUnitId", valid_578947
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

proc call*(call_578955: Call_AdexchangesellerAdunitsGet_578943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified ad unit in the specified ad client.
  ## 
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_AdexchangesellerAdunitsGet_578943; adClientId: string;
          adUnitId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerAdunitsGet
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
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "userIp", newJString(userIp))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(path_578957, "adClientId", newJString(adClientId))
  add(path_578957, "adUnitId", newJString(adUnitId))
  add(query_578958, "fields", newJString(fields))
  result = call_578956.call(path_578957, query_578958, nil, nil, nil)

var adexchangesellerAdunitsGet* = Call_AdexchangesellerAdunitsGet_578943(
    name: "adexchangesellerAdunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}",
    validator: validate_AdexchangesellerAdunitsGet_578944,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAdunitsGet_578945,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAdunitsCustomchannelsList_578959 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAdunitsCustomchannelsList_578961(protocol: Scheme;
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

proc validate_AdexchangesellerAdunitsCustomchannelsList_578960(path: JsonNode;
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
  var valid_578962 = path.getOrDefault("adClientId")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "adClientId", valid_578962
  var valid_578963 = path.getOrDefault("adUnitId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "adUnitId", valid_578963
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
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("maxResults")
  valid_578972 = validateParameter(valid_578972, JInt, required = false, default = nil)
  if valid_578972 != nil:
    section.add "maxResults", valid_578972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578973: Call_AdexchangesellerAdunitsCustomchannelsList_578959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels which the specified ad unit belongs to.
  ## 
  let valid = call_578973.validator(path, query, header, formData, body)
  let scheme = call_578973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578973.url(scheme.get, call_578973.host, call_578973.base,
                         call_578973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578973, url, valid)

proc call*(call_578974: Call_AdexchangesellerAdunitsCustomchannelsList_578959;
          adClientId: string; adUnitId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerAdunitsCustomchannelsList
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
  var path_578975 = newJObject()
  var query_578976 = newJObject()
  add(query_578976, "key", newJString(key))
  add(query_578976, "prettyPrint", newJBool(prettyPrint))
  add(query_578976, "oauth_token", newJString(oauthToken))
  add(query_578976, "alt", newJString(alt))
  add(query_578976, "userIp", newJString(userIp))
  add(query_578976, "quotaUser", newJString(quotaUser))
  add(query_578976, "pageToken", newJString(pageToken))
  add(path_578975, "adClientId", newJString(adClientId))
  add(path_578975, "adUnitId", newJString(adUnitId))
  add(query_578976, "fields", newJString(fields))
  add(query_578976, "maxResults", newJInt(maxResults))
  result = call_578974.call(path_578975, query_578976, nil, nil, nil)

var adexchangesellerAdunitsCustomchannelsList* = Call_AdexchangesellerAdunitsCustomchannelsList_578959(
    name: "adexchangesellerAdunitsCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/adunits/{adUnitId}/customchannels",
    validator: validate_AdexchangesellerAdunitsCustomchannelsList_578960,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerAdunitsCustomchannelsList_578961,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsList_578977 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerCustomchannelsList_578979(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerCustomchannelsList_578978(path: JsonNode;
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
  var valid_578980 = path.getOrDefault("adClientId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "adClientId", valid_578980
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
  var valid_578987 = query.getOrDefault("pageToken")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "pageToken", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  var valid_578989 = query.getOrDefault("maxResults")
  valid_578989 = validateParameter(valid_578989, JInt, required = false, default = nil)
  if valid_578989 != nil:
    section.add "maxResults", valid_578989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578990: Call_AdexchangesellerCustomchannelsList_578977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all custom channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_AdexchangesellerCustomchannelsList_578977;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adexchangesellerCustomchannelsList
  ## List all custom channels in the specified ad client for this Ad Exchange account.
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
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "userIp", newJString(userIp))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(query_578993, "pageToken", newJString(pageToken))
  add(path_578992, "adClientId", newJString(adClientId))
  add(query_578993, "fields", newJString(fields))
  add(query_578993, "maxResults", newJInt(maxResults))
  result = call_578991.call(path_578992, query_578993, nil, nil, nil)

var adexchangesellerCustomchannelsList* = Call_AdexchangesellerCustomchannelsList_578977(
    name: "adexchangesellerCustomchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/customchannels",
    validator: validate_AdexchangesellerCustomchannelsList_578978,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerCustomchannelsList_578979,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsGet_578994 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerCustomchannelsGet_578996(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerCustomchannelsGet_578995(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_578997 = path.getOrDefault("adClientId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "adClientId", valid_578997
  var valid_578998 = path.getOrDefault("customChannelId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "customChannelId", valid_578998
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
  if body != nil:
    result.add "body", body

proc call*(call_579006: Call_AdexchangesellerCustomchannelsGet_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified custom channel from the specified ad client.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_AdexchangesellerCustomchannelsGet_578994;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerCustomchannelsGet
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
  var path_579008 = newJObject()
  var query_579009 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "userIp", newJString(userIp))
  add(query_579009, "quotaUser", newJString(quotaUser))
  add(path_579008, "adClientId", newJString(adClientId))
  add(path_579008, "customChannelId", newJString(customChannelId))
  add(query_579009, "fields", newJString(fields))
  result = call_579007.call(path_579008, query_579009, nil, nil, nil)

var adexchangesellerCustomchannelsGet* = Call_AdexchangesellerCustomchannelsGet_578994(
    name: "adexchangesellerCustomchannelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}",
    validator: validate_AdexchangesellerCustomchannelsGet_578995,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerCustomchannelsGet_578996,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerCustomchannelsAdunitsList_579010 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerCustomchannelsAdunitsList_579012(protocol: Scheme;
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

proc validate_AdexchangesellerCustomchannelsAdunitsList_579011(path: JsonNode;
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
  var valid_579013 = path.getOrDefault("adClientId")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "adClientId", valid_579013
  var valid_579014 = path.getOrDefault("customChannelId")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "customChannelId", valid_579014
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
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("userIp")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "userIp", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("pageToken")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "pageToken", valid_579021
  var valid_579022 = query.getOrDefault("includeInactive")
  valid_579022 = validateParameter(valid_579022, JBool, required = false, default = nil)
  if valid_579022 != nil:
    section.add "includeInactive", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("maxResults")
  valid_579024 = validateParameter(valid_579024, JInt, required = false, default = nil)
  if valid_579024 != nil:
    section.add "maxResults", valid_579024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579025: Call_AdexchangesellerCustomchannelsAdunitsList_579010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all ad units in the specified custom channel.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_AdexchangesellerCustomchannelsAdunitsList_579010;
          adClientId: string; customChannelId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          includeInactive: bool = false; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerCustomchannelsAdunitsList
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
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "userIp", newJString(userIp))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(query_579028, "pageToken", newJString(pageToken))
  add(path_579027, "adClientId", newJString(adClientId))
  add(path_579027, "customChannelId", newJString(customChannelId))
  add(query_579028, "includeInactive", newJBool(includeInactive))
  add(query_579028, "fields", newJString(fields))
  add(query_579028, "maxResults", newJInt(maxResults))
  result = call_579026.call(path_579027, query_579028, nil, nil, nil)

var adexchangesellerCustomchannelsAdunitsList* = Call_AdexchangesellerCustomchannelsAdunitsList_579010(
    name: "adexchangesellerCustomchannelsAdunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/adclients/{adClientId}/customchannels/{customChannelId}/adunits",
    validator: validate_AdexchangesellerCustomchannelsAdunitsList_579011,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerCustomchannelsAdunitsList_579012,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerUrlchannelsList_579029 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerUrlchannelsList_579031(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerUrlchannelsList_579030(path: JsonNode;
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
  var valid_579032 = path.getOrDefault("adClientId")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "adClientId", valid_579032
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
  var valid_579033 = query.getOrDefault("key")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "key", valid_579033
  var valid_579034 = query.getOrDefault("prettyPrint")
  valid_579034 = validateParameter(valid_579034, JBool, required = false,
                                 default = newJBool(true))
  if valid_579034 != nil:
    section.add "prettyPrint", valid_579034
  var valid_579035 = query.getOrDefault("oauth_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "oauth_token", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("userIp")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "userIp", valid_579037
  var valid_579038 = query.getOrDefault("quotaUser")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "quotaUser", valid_579038
  var valid_579039 = query.getOrDefault("pageToken")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "pageToken", valid_579039
  var valid_579040 = query.getOrDefault("fields")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "fields", valid_579040
  var valid_579041 = query.getOrDefault("maxResults")
  valid_579041 = validateParameter(valid_579041, JInt, required = false, default = nil)
  if valid_579041 != nil:
    section.add "maxResults", valid_579041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579042: Call_AdexchangesellerUrlchannelsList_579029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all URL channels in the specified ad client for this Ad Exchange account.
  ## 
  let valid = call_579042.validator(path, query, header, formData, body)
  let scheme = call_579042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579042.url(scheme.get, call_579042.host, call_579042.base,
                         call_579042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579042, url, valid)

proc call*(call_579043: Call_AdexchangesellerUrlchannelsList_579029;
          adClientId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## adexchangesellerUrlchannelsList
  ## List all URL channels in the specified ad client for this Ad Exchange account.
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
  var path_579044 = newJObject()
  var query_579045 = newJObject()
  add(query_579045, "key", newJString(key))
  add(query_579045, "prettyPrint", newJBool(prettyPrint))
  add(query_579045, "oauth_token", newJString(oauthToken))
  add(query_579045, "alt", newJString(alt))
  add(query_579045, "userIp", newJString(userIp))
  add(query_579045, "quotaUser", newJString(quotaUser))
  add(query_579045, "pageToken", newJString(pageToken))
  add(path_579044, "adClientId", newJString(adClientId))
  add(query_579045, "fields", newJString(fields))
  add(query_579045, "maxResults", newJInt(maxResults))
  result = call_579043.call(path_579044, query_579045, nil, nil, nil)

var adexchangesellerUrlchannelsList* = Call_AdexchangesellerUrlchannelsList_579029(
    name: "adexchangesellerUrlchannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/adclients/{adClientId}/urlchannels",
    validator: validate_AdexchangesellerUrlchannelsList_579030,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerUrlchannelsList_579031,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerAlertsList_579046 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerAlertsList_579048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerAlertsList_579047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the alerts for this Ad Exchange account.
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
  var valid_579049 = query.getOrDefault("key")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "key", valid_579049
  var valid_579050 = query.getOrDefault("prettyPrint")
  valid_579050 = validateParameter(valid_579050, JBool, required = false,
                                 default = newJBool(true))
  if valid_579050 != nil:
    section.add "prettyPrint", valid_579050
  var valid_579051 = query.getOrDefault("oauth_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "oauth_token", valid_579051
  var valid_579052 = query.getOrDefault("locale")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "locale", valid_579052
  var valid_579053 = query.getOrDefault("alt")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("json"))
  if valid_579053 != nil:
    section.add "alt", valid_579053
  var valid_579054 = query.getOrDefault("userIp")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "userIp", valid_579054
  var valid_579055 = query.getOrDefault("quotaUser")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "quotaUser", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579057: Call_AdexchangesellerAlertsList_579046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the alerts for this Ad Exchange account.
  ## 
  let valid = call_579057.validator(path, query, header, formData, body)
  let scheme = call_579057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579057.url(scheme.get, call_579057.host, call_579057.base,
                         call_579057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579057, url, valid)

proc call*(call_579058: Call_AdexchangesellerAlertsList_579046; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerAlertsList
  ## List the alerts for this Ad Exchange account.
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
  var query_579059 = newJObject()
  add(query_579059, "key", newJString(key))
  add(query_579059, "prettyPrint", newJBool(prettyPrint))
  add(query_579059, "oauth_token", newJString(oauthToken))
  add(query_579059, "locale", newJString(locale))
  add(query_579059, "alt", newJString(alt))
  add(query_579059, "userIp", newJString(userIp))
  add(query_579059, "quotaUser", newJString(quotaUser))
  add(query_579059, "fields", newJString(fields))
  result = call_579058.call(nil, query_579059, nil, nil, nil)

var adexchangesellerAlertsList* = Call_AdexchangesellerAlertsList_579046(
    name: "adexchangesellerAlertsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/alerts",
    validator: validate_AdexchangesellerAlertsList_579047,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerAlertsList_579048,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerMetadataDimensionsList_579060 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerMetadataDimensionsList_579062(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerMetadataDimensionsList_579061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the dimensions available to this AdExchange account.
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
  var valid_579063 = query.getOrDefault("key")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "key", valid_579063
  var valid_579064 = query.getOrDefault("prettyPrint")
  valid_579064 = validateParameter(valid_579064, JBool, required = false,
                                 default = newJBool(true))
  if valid_579064 != nil:
    section.add "prettyPrint", valid_579064
  var valid_579065 = query.getOrDefault("oauth_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "oauth_token", valid_579065
  var valid_579066 = query.getOrDefault("alt")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = newJString("json"))
  if valid_579066 != nil:
    section.add "alt", valid_579066
  var valid_579067 = query.getOrDefault("userIp")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "userIp", valid_579067
  var valid_579068 = query.getOrDefault("quotaUser")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "quotaUser", valid_579068
  var valid_579069 = query.getOrDefault("fields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "fields", valid_579069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579070: Call_AdexchangesellerMetadataDimensionsList_579060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the dimensions available to this AdExchange account.
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_AdexchangesellerMetadataDimensionsList_579060;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerMetadataDimensionsList
  ## List the metadata for the dimensions available to this AdExchange account.
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
  var query_579072 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "userIp", newJString(userIp))
  add(query_579072, "quotaUser", newJString(quotaUser))
  add(query_579072, "fields", newJString(fields))
  result = call_579071.call(nil, query_579072, nil, nil, nil)

var adexchangesellerMetadataDimensionsList* = Call_AdexchangesellerMetadataDimensionsList_579060(
    name: "adexchangesellerMetadataDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/dimensions",
    validator: validate_AdexchangesellerMetadataDimensionsList_579061,
    base: "/adexchangeseller/v1.1",
    url: url_AdexchangesellerMetadataDimensionsList_579062,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerMetadataMetricsList_579073 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerMetadataMetricsList_579075(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerMetadataMetricsList_579074(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the metadata for the metrics available to this AdExchange account.
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
  var valid_579076 = query.getOrDefault("key")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "key", valid_579076
  var valid_579077 = query.getOrDefault("prettyPrint")
  valid_579077 = validateParameter(valid_579077, JBool, required = false,
                                 default = newJBool(true))
  if valid_579077 != nil:
    section.add "prettyPrint", valid_579077
  var valid_579078 = query.getOrDefault("oauth_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "oauth_token", valid_579078
  var valid_579079 = query.getOrDefault("alt")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("json"))
  if valid_579079 != nil:
    section.add "alt", valid_579079
  var valid_579080 = query.getOrDefault("userIp")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "userIp", valid_579080
  var valid_579081 = query.getOrDefault("quotaUser")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "quotaUser", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579083: Call_AdexchangesellerMetadataMetricsList_579073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the metadata for the metrics available to this AdExchange account.
  ## 
  let valid = call_579083.validator(path, query, header, formData, body)
  let scheme = call_579083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579083.url(scheme.get, call_579083.host, call_579083.base,
                         call_579083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579083, url, valid)

proc call*(call_579084: Call_AdexchangesellerMetadataMetricsList_579073;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerMetadataMetricsList
  ## List the metadata for the metrics available to this AdExchange account.
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
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "userIp", newJString(userIp))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(query_579085, "fields", newJString(fields))
  result = call_579084.call(nil, query_579085, nil, nil, nil)

var adexchangesellerMetadataMetricsList* = Call_AdexchangesellerMetadataMetricsList_579073(
    name: "adexchangesellerMetadataMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/metrics",
    validator: validate_AdexchangesellerMetadataMetricsList_579074,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerMetadataMetricsList_579075,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerPreferreddealsList_579086 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerPreferreddealsList_579088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerPreferreddealsList_579087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the preferred deals for this Ad Exchange account.
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("userIp")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "userIp", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_AdexchangesellerPreferreddealsList_579086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the preferred deals for this Ad Exchange account.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_AdexchangesellerPreferreddealsList_579086;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## adexchangesellerPreferreddealsList
  ## List the preferred deals for this Ad Exchange account.
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
  var query_579098 = newJObject()
  add(query_579098, "key", newJString(key))
  add(query_579098, "prettyPrint", newJBool(prettyPrint))
  add(query_579098, "oauth_token", newJString(oauthToken))
  add(query_579098, "alt", newJString(alt))
  add(query_579098, "userIp", newJString(userIp))
  add(query_579098, "quotaUser", newJString(quotaUser))
  add(query_579098, "fields", newJString(fields))
  result = call_579097.call(nil, query_579098, nil, nil, nil)

var adexchangesellerPreferreddealsList* = Call_AdexchangesellerPreferreddealsList_579086(
    name: "adexchangesellerPreferreddealsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/preferreddeals",
    validator: validate_AdexchangesellerPreferreddealsList_579087,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerPreferreddealsList_579088,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerPreferreddealsGet_579099 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerPreferreddealsGet_579101(protocol: Scheme; host: string;
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

proc validate_AdexchangesellerPreferreddealsGet_579100(path: JsonNode;
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
  var valid_579102 = path.getOrDefault("dealId")
  valid_579102 = validateParameter(valid_579102, JString, required = true,
                                 default = nil)
  if valid_579102 != nil:
    section.add "dealId", valid_579102
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
  var valid_579103 = query.getOrDefault("key")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "key", valid_579103
  var valid_579104 = query.getOrDefault("prettyPrint")
  valid_579104 = validateParameter(valid_579104, JBool, required = false,
                                 default = newJBool(true))
  if valid_579104 != nil:
    section.add "prettyPrint", valid_579104
  var valid_579105 = query.getOrDefault("oauth_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "oauth_token", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("userIp")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "userIp", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("fields")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "fields", valid_579109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_AdexchangesellerPreferreddealsGet_579099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about the selected Ad Exchange Preferred Deal.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_AdexchangesellerPreferreddealsGet_579099;
          dealId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## adexchangesellerPreferreddealsGet
  ## Get information about the selected Ad Exchange Preferred Deal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   dealId: string (required)
  ##         : Preferred deal to get information about.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(path_579112, "dealId", newJString(dealId))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "userIp", newJString(userIp))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "fields", newJString(fields))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var adexchangesellerPreferreddealsGet* = Call_AdexchangesellerPreferreddealsGet_579099(
    name: "adexchangesellerPreferreddealsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/preferreddeals/{dealId}",
    validator: validate_AdexchangesellerPreferreddealsGet_579100,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerPreferreddealsGet_579101,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsGenerate_579114 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerReportsGenerate_579116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsGenerate_579115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  var valid_579117 = query.getOrDefault("key")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "key", valid_579117
  var valid_579118 = query.getOrDefault("prettyPrint")
  valid_579118 = validateParameter(valid_579118, JBool, required = false,
                                 default = newJBool(true))
  if valid_579118 != nil:
    section.add "prettyPrint", valid_579118
  var valid_579119 = query.getOrDefault("oauth_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "oauth_token", valid_579119
  var valid_579120 = query.getOrDefault("locale")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "locale", valid_579120
  var valid_579121 = query.getOrDefault("alt")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = newJString("json"))
  if valid_579121 != nil:
    section.add "alt", valid_579121
  var valid_579122 = query.getOrDefault("userIp")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "userIp", valid_579122
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_579123 = query.getOrDefault("endDate")
  valid_579123 = validateParameter(valid_579123, JString, required = true,
                                 default = nil)
  if valid_579123 != nil:
    section.add "endDate", valid_579123
  var valid_579124 = query.getOrDefault("quotaUser")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "quotaUser", valid_579124
  var valid_579125 = query.getOrDefault("startIndex")
  valid_579125 = validateParameter(valid_579125, JInt, required = false, default = nil)
  if valid_579125 != nil:
    section.add "startIndex", valid_579125
  var valid_579126 = query.getOrDefault("filter")
  valid_579126 = validateParameter(valid_579126, JArray, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "filter", valid_579126
  var valid_579127 = query.getOrDefault("dimension")
  valid_579127 = validateParameter(valid_579127, JArray, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "dimension", valid_579127
  var valid_579128 = query.getOrDefault("metric")
  valid_579128 = validateParameter(valid_579128, JArray, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "metric", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  var valid_579130 = query.getOrDefault("startDate")
  valid_579130 = validateParameter(valid_579130, JString, required = true,
                                 default = nil)
  if valid_579130 != nil:
    section.add "startDate", valid_579130
  var valid_579131 = query.getOrDefault("maxResults")
  valid_579131 = validateParameter(valid_579131, JInt, required = false, default = nil)
  if valid_579131 != nil:
    section.add "maxResults", valid_579131
  var valid_579132 = query.getOrDefault("sort")
  valid_579132 = validateParameter(valid_579132, JArray, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "sort", valid_579132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579133: Call_AdexchangesellerReportsGenerate_579114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_AdexchangesellerReportsGenerate_579114;
          endDate: string; startDate: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; locale: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; filter: JsonNode = nil; dimension: JsonNode = nil;
          metric: JsonNode = nil; fields: string = ""; maxResults: int = 0;
          sort: JsonNode = nil): Recallable =
  ## adexchangesellerReportsGenerate
  ## Generate an Ad Exchange report based on the report request sent in the query parameters. Returns the result as JSON; to retrieve output in CSV format specify "alt=csv" as a query parameter.
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
  var query_579135 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(query_579135, "locale", newJString(locale))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "userIp", newJString(userIp))
  add(query_579135, "endDate", newJString(endDate))
  add(query_579135, "quotaUser", newJString(quotaUser))
  add(query_579135, "startIndex", newJInt(startIndex))
  if filter != nil:
    query_579135.add "filter", filter
  if dimension != nil:
    query_579135.add "dimension", dimension
  if metric != nil:
    query_579135.add "metric", metric
  add(query_579135, "fields", newJString(fields))
  add(query_579135, "startDate", newJString(startDate))
  add(query_579135, "maxResults", newJInt(maxResults))
  if sort != nil:
    query_579135.add "sort", sort
  result = call_579134.call(nil, query_579135, nil, nil, nil)

var adexchangesellerReportsGenerate* = Call_AdexchangesellerReportsGenerate_579114(
    name: "adexchangesellerReportsGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_AdexchangesellerReportsGenerate_579115,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsGenerate_579116,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedList_579136 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerReportsSavedList_579138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdexchangesellerReportsSavedList_579137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all saved reports in this Ad Exchange account.
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
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("alt")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("json"))
  if valid_579142 != nil:
    section.add "alt", valid_579142
  var valid_579143 = query.getOrDefault("userIp")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "userIp", valid_579143
  var valid_579144 = query.getOrDefault("quotaUser")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "quotaUser", valid_579144
  var valid_579145 = query.getOrDefault("pageToken")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "pageToken", valid_579145
  var valid_579146 = query.getOrDefault("fields")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "fields", valid_579146
  var valid_579147 = query.getOrDefault("maxResults")
  valid_579147 = validateParameter(valid_579147, JInt, required = false, default = nil)
  if valid_579147 != nil:
    section.add "maxResults", valid_579147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579148: Call_AdexchangesellerReportsSavedList_579136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all saved reports in this Ad Exchange account.
  ## 
  let valid = call_579148.validator(path, query, header, formData, body)
  let scheme = call_579148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579148.url(scheme.get, call_579148.host, call_579148.base,
                         call_579148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579148, url, valid)

proc call*(call_579149: Call_AdexchangesellerReportsSavedList_579136;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerReportsSavedList
  ## List all saved reports in this Ad Exchange account.
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
  var query_579150 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "userIp", newJString(userIp))
  add(query_579150, "quotaUser", newJString(quotaUser))
  add(query_579150, "pageToken", newJString(pageToken))
  add(query_579150, "fields", newJString(fields))
  add(query_579150, "maxResults", newJInt(maxResults))
  result = call_579149.call(nil, query_579150, nil, nil, nil)

var adexchangesellerReportsSavedList* = Call_AdexchangesellerReportsSavedList_579136(
    name: "adexchangesellerReportsSavedList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/saved",
    validator: validate_AdexchangesellerReportsSavedList_579137,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsSavedList_579138,
    schemes: {Scheme.Https})
type
  Call_AdexchangesellerReportsSavedGenerate_579151 = ref object of OpenApiRestCall_578355
proc url_AdexchangesellerReportsSavedGenerate_579153(protocol: Scheme;
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

proc validate_AdexchangesellerReportsSavedGenerate_579152(path: JsonNode;
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
  var valid_579154 = path.getOrDefault("savedReportId")
  valid_579154 = validateParameter(valid_579154, JString, required = true,
                                 default = nil)
  if valid_579154 != nil:
    section.add "savedReportId", valid_579154
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
  var valid_579159 = query.getOrDefault("alt")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("json"))
  if valid_579159 != nil:
    section.add "alt", valid_579159
  var valid_579160 = query.getOrDefault("userIp")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "userIp", valid_579160
  var valid_579161 = query.getOrDefault("quotaUser")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "quotaUser", valid_579161
  var valid_579162 = query.getOrDefault("startIndex")
  valid_579162 = validateParameter(valid_579162, JInt, required = false, default = nil)
  if valid_579162 != nil:
    section.add "startIndex", valid_579162
  var valid_579163 = query.getOrDefault("fields")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "fields", valid_579163
  var valid_579164 = query.getOrDefault("maxResults")
  valid_579164 = validateParameter(valid_579164, JInt, required = false, default = nil)
  if valid_579164 != nil:
    section.add "maxResults", valid_579164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579165: Call_AdexchangesellerReportsSavedGenerate_579151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
  ## 
  let valid = call_579165.validator(path, query, header, formData, body)
  let scheme = call_579165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579165.url(scheme.get, call_579165.host, call_579165.base,
                         call_579165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579165, url, valid)

proc call*(call_579166: Call_AdexchangesellerReportsSavedGenerate_579151;
          savedReportId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; locale: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: int = 0;
          fields: string = ""; maxResults: int = 0): Recallable =
  ## adexchangesellerReportsSavedGenerate
  ## Generate an Ad Exchange report based on the saved report ID sent in the query parameters.
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
  var path_579167 = newJObject()
  var query_579168 = newJObject()
  add(query_579168, "key", newJString(key))
  add(query_579168, "prettyPrint", newJBool(prettyPrint))
  add(query_579168, "oauth_token", newJString(oauthToken))
  add(query_579168, "locale", newJString(locale))
  add(query_579168, "alt", newJString(alt))
  add(query_579168, "userIp", newJString(userIp))
  add(path_579167, "savedReportId", newJString(savedReportId))
  add(query_579168, "quotaUser", newJString(quotaUser))
  add(query_579168, "startIndex", newJInt(startIndex))
  add(query_579168, "fields", newJString(fields))
  add(query_579168, "maxResults", newJInt(maxResults))
  result = call_579166.call(path_579167, query_579168, nil, nil, nil)

var adexchangesellerReportsSavedGenerate* = Call_AdexchangesellerReportsSavedGenerate_579151(
    name: "adexchangesellerReportsSavedGenerate", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{savedReportId}",
    validator: validate_AdexchangesellerReportsSavedGenerate_579152,
    base: "/adexchangeseller/v1.1", url: url_AdexchangesellerReportsSavedGenerate_579153,
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
