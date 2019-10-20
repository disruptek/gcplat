
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Search Ads 360
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reports and modifies your advertising data in DoubleClick Search (for example, campaigns, ad groups, keywords, and conversions).
## 
## https://developers.google.com/doubleclick-search/
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
  gcpServiceName = "doubleclicksearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclicksearchConversionGet_578625 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchConversionGet_578627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "agencyId" in path, "`agencyId` is a required path parameter"
  assert "advertiserId" in path, "`advertiserId` is a required path parameter"
  assert "engineAccountId" in path, "`engineAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/agency/"),
               (kind: VariableSegment, value: "agencyId"),
               (kind: ConstantSegment, value: "/advertiser/"),
               (kind: VariableSegment, value: "advertiserId"),
               (kind: ConstantSegment, value: "/engine/"),
               (kind: VariableSegment, value: "engineAccountId"),
               (kind: ConstantSegment, value: "/conversion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchConversionGet_578626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   engineAccountId: JString (required)
  ##                  : Numeric ID of the engine account.
  ##   advertiserId: JString (required)
  ##               : Numeric ID of the advertiser.
  ##   agencyId: JString (required)
  ##           : Numeric ID of the agency.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `engineAccountId` field"
  var valid_578753 = path.getOrDefault("engineAccountId")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "engineAccountId", valid_578753
  var valid_578754 = path.getOrDefault("advertiserId")
  valid_578754 = validateParameter(valid_578754, JString, required = true,
                                 default = nil)
  if valid_578754 != nil:
    section.add "advertiserId", valid_578754
  var valid_578755 = path.getOrDefault("agencyId")
  valid_578755 = validateParameter(valid_578755, JString, required = true,
                                 default = nil)
  if valid_578755 != nil:
    section.add "agencyId", valid_578755
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   adId: JString
  ##       : Numeric ID of the ad.
  ##   criterionId: JString
  ##              : Numeric ID of the criterion.
  ##   startRow: JInt (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JInt (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   campaignId: JString
  ##             : Numeric ID of the campaign.
  ##   adGroupId: JString
  ##            : Numeric ID of the ad group.
  ##   rowCount: JInt (required)
  ##           : The number of conversions to return per call.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JInt (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  section = newJObject()
  var valid_578756 = query.getOrDefault("key")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "key", valid_578756
  var valid_578770 = query.getOrDefault("prettyPrint")
  valid_578770 = validateParameter(valid_578770, JBool, required = false,
                                 default = newJBool(true))
  if valid_578770 != nil:
    section.add "prettyPrint", valid_578770
  var valid_578771 = query.getOrDefault("oauth_token")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "oauth_token", valid_578771
  var valid_578772 = query.getOrDefault("adId")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "adId", valid_578772
  var valid_578773 = query.getOrDefault("criterionId")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "criterionId", valid_578773
  assert query != nil,
        "query argument is necessary due to required `startRow` field"
  var valid_578774 = query.getOrDefault("startRow")
  valid_578774 = validateParameter(valid_578774, JInt, required = true, default = nil)
  if valid_578774 != nil:
    section.add "startRow", valid_578774
  var valid_578775 = query.getOrDefault("alt")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = newJString("json"))
  if valid_578775 != nil:
    section.add "alt", valid_578775
  var valid_578776 = query.getOrDefault("userIp")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "userIp", valid_578776
  var valid_578777 = query.getOrDefault("endDate")
  valid_578777 = validateParameter(valid_578777, JInt, required = true, default = nil)
  if valid_578777 != nil:
    section.add "endDate", valid_578777
  var valid_578778 = query.getOrDefault("quotaUser")
  valid_578778 = validateParameter(valid_578778, JString, required = false,
                                 default = nil)
  if valid_578778 != nil:
    section.add "quotaUser", valid_578778
  var valid_578779 = query.getOrDefault("campaignId")
  valid_578779 = validateParameter(valid_578779, JString, required = false,
                                 default = nil)
  if valid_578779 != nil:
    section.add "campaignId", valid_578779
  var valid_578780 = query.getOrDefault("adGroupId")
  valid_578780 = validateParameter(valid_578780, JString, required = false,
                                 default = nil)
  if valid_578780 != nil:
    section.add "adGroupId", valid_578780
  var valid_578781 = query.getOrDefault("rowCount")
  valid_578781 = validateParameter(valid_578781, JInt, required = true, default = nil)
  if valid_578781 != nil:
    section.add "rowCount", valid_578781
  var valid_578782 = query.getOrDefault("fields")
  valid_578782 = validateParameter(valid_578782, JString, required = false,
                                 default = nil)
  if valid_578782 != nil:
    section.add "fields", valid_578782
  var valid_578783 = query.getOrDefault("startDate")
  valid_578783 = validateParameter(valid_578783, JInt, required = true, default = nil)
  if valid_578783 != nil:
    section.add "startDate", valid_578783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578806: Call_DoubleclicksearchConversionGet_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  let valid = call_578806.validator(path, query, header, formData, body)
  let scheme = call_578806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578806.url(scheme.get, call_578806.host, call_578806.base,
                         call_578806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578806, url, valid)

proc call*(call_578877: Call_DoubleclicksearchConversionGet_578625;
          engineAccountId: string; startRow: int; endDate: int; advertiserId: string;
          rowCount: int; agencyId: string; startDate: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; adId: string = "";
          criterionId: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; campaignId: string = ""; adGroupId: string = "";
          fields: string = ""): Recallable =
  ## doubleclicksearchConversionGet
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   adId: string
  ##       : Numeric ID of the ad.
  ##   criterionId: string
  ##              : Numeric ID of the criterion.
  ##   engineAccountId: string (required)
  ##                  : Numeric ID of the engine account.
  ##   startRow: int (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: int (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   campaignId: string
  ##             : Numeric ID of the campaign.
  ##   adGroupId: string
  ##            : Numeric ID of the ad group.
  ##   advertiserId: string (required)
  ##               : Numeric ID of the advertiser.
  ##   rowCount: int (required)
  ##           : The number of conversions to return per call.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   agencyId: string (required)
  ##           : Numeric ID of the agency.
  ##   startDate: int (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  var path_578878 = newJObject()
  var query_578880 = newJObject()
  add(query_578880, "key", newJString(key))
  add(query_578880, "prettyPrint", newJBool(prettyPrint))
  add(query_578880, "oauth_token", newJString(oauthToken))
  add(query_578880, "adId", newJString(adId))
  add(query_578880, "criterionId", newJString(criterionId))
  add(path_578878, "engineAccountId", newJString(engineAccountId))
  add(query_578880, "startRow", newJInt(startRow))
  add(query_578880, "alt", newJString(alt))
  add(query_578880, "userIp", newJString(userIp))
  add(query_578880, "endDate", newJInt(endDate))
  add(query_578880, "quotaUser", newJString(quotaUser))
  add(query_578880, "campaignId", newJString(campaignId))
  add(query_578880, "adGroupId", newJString(adGroupId))
  add(path_578878, "advertiserId", newJString(advertiserId))
  add(query_578880, "rowCount", newJInt(rowCount))
  add(query_578880, "fields", newJString(fields))
  add(path_578878, "agencyId", newJString(agencyId))
  add(query_578880, "startDate", newJInt(startDate))
  result = call_578877.call(path_578878, query_578880, nil, nil, nil)

var doubleclicksearchConversionGet* = Call_DoubleclicksearchConversionGet_578625(
    name: "doubleclicksearchConversionGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/agency/{agencyId}/advertiser/{advertiserId}/engine/{engineAccountId}/conversion",
    validator: validate_DoubleclicksearchConversionGet_578626,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionGet_578627,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchSavedColumnsList_578919 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchSavedColumnsList_578921(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "agencyId" in path, "`agencyId` is a required path parameter"
  assert "advertiserId" in path, "`advertiserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/agency/"),
               (kind: VariableSegment, value: "agencyId"),
               (kind: ConstantSegment, value: "/advertiser/"),
               (kind: VariableSegment, value: "advertiserId"),
               (kind: ConstantSegment, value: "/savedcolumns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchSavedColumnsList_578920(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   advertiserId: JString (required)
  ##               : DS ID of the advertiser.
  ##   agencyId: JString (required)
  ##           : DS ID of the agency.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `advertiserId` field"
  var valid_578922 = path.getOrDefault("advertiserId")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "advertiserId", valid_578922
  var valid_578923 = path.getOrDefault("agencyId")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "agencyId", valid_578923
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
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("prettyPrint")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "prettyPrint", valid_578925
  var valid_578926 = query.getOrDefault("oauth_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "oauth_token", valid_578926
  var valid_578927 = query.getOrDefault("alt")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("json"))
  if valid_578927 != nil:
    section.add "alt", valid_578927
  var valid_578928 = query.getOrDefault("userIp")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "userIp", valid_578928
  var valid_578929 = query.getOrDefault("quotaUser")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "quotaUser", valid_578929
  var valid_578930 = query.getOrDefault("fields")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "fields", valid_578930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578931: Call_DoubleclicksearchSavedColumnsList_578919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  let valid = call_578931.validator(path, query, header, formData, body)
  let scheme = call_578931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578931.url(scheme.get, call_578931.host, call_578931.base,
                         call_578931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578931, url, valid)

proc call*(call_578932: Call_DoubleclicksearchSavedColumnsList_578919;
          advertiserId: string; agencyId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## doubleclicksearchSavedColumnsList
  ## Retrieve the list of saved columns for a specified advertiser.
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
  ##   advertiserId: string (required)
  ##               : DS ID of the advertiser.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   agencyId: string (required)
  ##           : DS ID of the agency.
  var path_578933 = newJObject()
  var query_578934 = newJObject()
  add(query_578934, "key", newJString(key))
  add(query_578934, "prettyPrint", newJBool(prettyPrint))
  add(query_578934, "oauth_token", newJString(oauthToken))
  add(query_578934, "alt", newJString(alt))
  add(query_578934, "userIp", newJString(userIp))
  add(query_578934, "quotaUser", newJString(quotaUser))
  add(path_578933, "advertiserId", newJString(advertiserId))
  add(query_578934, "fields", newJString(fields))
  add(path_578933, "agencyId", newJString(agencyId))
  result = call_578932.call(path_578933, query_578934, nil, nil, nil)

var doubleclicksearchSavedColumnsList* = Call_DoubleclicksearchSavedColumnsList_578919(
    name: "doubleclicksearchSavedColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/agency/{agencyId}/advertiser/{advertiserId}/savedcolumns",
    validator: validate_DoubleclicksearchSavedColumnsList_578920,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchSavedColumnsList_578921,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdate_578935 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchConversionUpdate_578937(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdate_578936(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a batch of conversions in DoubleClick Search.
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
  var valid_578938 = query.getOrDefault("key")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "key", valid_578938
  var valid_578939 = query.getOrDefault("prettyPrint")
  valid_578939 = validateParameter(valid_578939, JBool, required = false,
                                 default = newJBool(true))
  if valid_578939 != nil:
    section.add "prettyPrint", valid_578939
  var valid_578940 = query.getOrDefault("oauth_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "oauth_token", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("userIp")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "userIp", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
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

proc call*(call_578946: Call_DoubleclicksearchConversionUpdate_578935;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_DoubleclicksearchConversionUpdate_578935;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclicksearchConversionUpdate
  ## Updates a batch of conversions in DoubleClick Search.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578948 = newJObject()
  var body_578949 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "userIp", newJString(userIp))
  add(query_578948, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578949 = body
  add(query_578948, "fields", newJString(fields))
  result = call_578947.call(nil, query_578948, nil, nil, body_578949)

var doubleclicksearchConversionUpdate* = Call_DoubleclicksearchConversionUpdate_578935(
    name: "doubleclicksearchConversionUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionUpdate_578936,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionUpdate_578937,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionInsert_578950 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchConversionInsert_578952(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionInsert_578951(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a batch of new conversions into DoubleClick Search.
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
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("prettyPrint")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(true))
  if valid_578954 != nil:
    section.add "prettyPrint", valid_578954
  var valid_578955 = query.getOrDefault("oauth_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "oauth_token", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("userIp")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "userIp", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
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

proc call*(call_578961: Call_DoubleclicksearchConversionInsert_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a batch of new conversions into DoubleClick Search.
  ## 
  let valid = call_578961.validator(path, query, header, formData, body)
  let scheme = call_578961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578961.url(scheme.get, call_578961.host, call_578961.base,
                         call_578961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578961, url, valid)

proc call*(call_578962: Call_DoubleclicksearchConversionInsert_578950;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclicksearchConversionInsert
  ## Inserts a batch of new conversions into DoubleClick Search.
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
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578963 = newJObject()
  var body_578964 = newJObject()
  add(query_578963, "key", newJString(key))
  add(query_578963, "prettyPrint", newJBool(prettyPrint))
  add(query_578963, "oauth_token", newJString(oauthToken))
  add(query_578963, "alt", newJString(alt))
  add(query_578963, "userIp", newJString(userIp))
  add(query_578963, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578964 = body
  add(query_578963, "fields", newJString(fields))
  result = call_578962.call(nil, query_578963, nil, nil, body_578964)

var doubleclicksearchConversionInsert* = Call_DoubleclicksearchConversionInsert_578950(
    name: "doubleclicksearchConversionInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionInsert_578951,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionInsert_578952,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionPatch_578965 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchConversionPatch_578967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionPatch_578966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
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
  ##   engineAccountId: JString (required)
  ##                  : Numeric ID of the engine account.
  ##   startRow: JInt (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JInt (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   advertiserId: JString (required)
  ##               : Numeric ID of the advertiser.
  ##   agencyId: JString (required)
  ##           : Numeric ID of the agency.
  ##   rowCount: JInt (required)
  ##           : The number of conversions to return per call.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JInt (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
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
  assert query != nil,
        "query argument is necessary due to required `engineAccountId` field"
  var valid_578971 = query.getOrDefault("engineAccountId")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "engineAccountId", valid_578971
  var valid_578972 = query.getOrDefault("startRow")
  valid_578972 = validateParameter(valid_578972, JInt, required = true, default = nil)
  if valid_578972 != nil:
    section.add "startRow", valid_578972
  var valid_578973 = query.getOrDefault("alt")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("json"))
  if valid_578973 != nil:
    section.add "alt", valid_578973
  var valid_578974 = query.getOrDefault("userIp")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "userIp", valid_578974
  var valid_578975 = query.getOrDefault("endDate")
  valid_578975 = validateParameter(valid_578975, JInt, required = true, default = nil)
  if valid_578975 != nil:
    section.add "endDate", valid_578975
  var valid_578976 = query.getOrDefault("quotaUser")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "quotaUser", valid_578976
  var valid_578977 = query.getOrDefault("advertiserId")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "advertiserId", valid_578977
  var valid_578978 = query.getOrDefault("agencyId")
  valid_578978 = validateParameter(valid_578978, JString, required = true,
                                 default = nil)
  if valid_578978 != nil:
    section.add "agencyId", valid_578978
  var valid_578979 = query.getOrDefault("rowCount")
  valid_578979 = validateParameter(valid_578979, JInt, required = true, default = nil)
  if valid_578979 != nil:
    section.add "rowCount", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  var valid_578981 = query.getOrDefault("startDate")
  valid_578981 = validateParameter(valid_578981, JInt, required = true, default = nil)
  if valid_578981 != nil:
    section.add "startDate", valid_578981
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

proc call*(call_578983: Call_DoubleclicksearchConversionPatch_578965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_DoubleclicksearchConversionPatch_578965;
          engineAccountId: string; startRow: int; endDate: int; advertiserId: string;
          agencyId: string; rowCount: int; startDate: int; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## doubleclicksearchConversionPatch
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   engineAccountId: string (required)
  ##                  : Numeric ID of the engine account.
  ##   startRow: int (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: int (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   advertiserId: string (required)
  ##               : Numeric ID of the advertiser.
  ##   body: JObject
  ##   agencyId: string (required)
  ##           : Numeric ID of the agency.
  ##   rowCount: int (required)
  ##           : The number of conversions to return per call.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: int (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  var query_578985 = newJObject()
  var body_578986 = newJObject()
  add(query_578985, "key", newJString(key))
  add(query_578985, "prettyPrint", newJBool(prettyPrint))
  add(query_578985, "oauth_token", newJString(oauthToken))
  add(query_578985, "engineAccountId", newJString(engineAccountId))
  add(query_578985, "startRow", newJInt(startRow))
  add(query_578985, "alt", newJString(alt))
  add(query_578985, "userIp", newJString(userIp))
  add(query_578985, "endDate", newJInt(endDate))
  add(query_578985, "quotaUser", newJString(quotaUser))
  add(query_578985, "advertiserId", newJString(advertiserId))
  if body != nil:
    body_578986 = body
  add(query_578985, "agencyId", newJString(agencyId))
  add(query_578985, "rowCount", newJInt(rowCount))
  add(query_578985, "fields", newJString(fields))
  add(query_578985, "startDate", newJInt(startDate))
  result = call_578984.call(nil, query_578985, nil, nil, body_578986)

var doubleclicksearchConversionPatch* = Call_DoubleclicksearchConversionPatch_578965(
    name: "doubleclicksearchConversionPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionPatch_578966,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionPatch_578967,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdateAvailability_578987 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchConversionUpdateAvailability_578989(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdateAvailability_578988(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
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
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("userIp")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "userIp", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("fields")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "fields", valid_578996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   empty: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578998: Call_DoubleclicksearchConversionUpdateAvailability_578987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ## 
  let valid = call_578998.validator(path, query, header, formData, body)
  let scheme = call_578998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578998.url(scheme.get, call_578998.host, call_578998.base,
                         call_578998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578998, url, valid)

proc call*(call_578999: Call_DoubleclicksearchConversionUpdateAvailability_578987;
          key: string = ""; empty: JsonNode = nil; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## doubleclicksearchConversionUpdateAvailability
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   empty: JObject
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
  var query_579000 = newJObject()
  var body_579001 = newJObject()
  add(query_579000, "key", newJString(key))
  if empty != nil:
    body_579001 = empty
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "userIp", newJString(userIp))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(query_579000, "fields", newJString(fields))
  result = call_578999.call(nil, query_579000, nil, nil, body_579001)

var doubleclicksearchConversionUpdateAvailability* = Call_DoubleclicksearchConversionUpdateAvailability_578987(
    name: "doubleclicksearchConversionUpdateAvailability",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/conversion/updateAvailability",
    validator: validate_DoubleclicksearchConversionUpdateAvailability_578988,
    base: "/doubleclicksearch/v2",
    url: url_DoubleclicksearchConversionUpdateAvailability_578989,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsRequest_579002 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchReportsRequest_579004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsRequest_579003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a report request into the reporting system.
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
  var valid_579005 = query.getOrDefault("key")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "key", valid_579005
  var valid_579006 = query.getOrDefault("prettyPrint")
  valid_579006 = validateParameter(valid_579006, JBool, required = false,
                                 default = newJBool(true))
  if valid_579006 != nil:
    section.add "prettyPrint", valid_579006
  var valid_579007 = query.getOrDefault("oauth_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "oauth_token", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("userIp")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "userIp", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("fields")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "fields", valid_579011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reportRequest: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579013: Call_DoubleclicksearchReportsRequest_579002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a report request into the reporting system.
  ## 
  let valid = call_579013.validator(path, query, header, formData, body)
  let scheme = call_579013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579013.url(scheme.get, call_579013.host, call_579013.base,
                         call_579013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579013, url, valid)

proc call*(call_579014: Call_DoubleclicksearchReportsRequest_579002;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          reportRequest: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclicksearchReportsRequest
  ## Inserts a report request into the reporting system.
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
  ##   reportRequest: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579015 = newJObject()
  var body_579016 = newJObject()
  add(query_579015, "key", newJString(key))
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "userIp", newJString(userIp))
  add(query_579015, "quotaUser", newJString(quotaUser))
  if reportRequest != nil:
    body_579016 = reportRequest
  add(query_579015, "fields", newJString(fields))
  result = call_579014.call(nil, query_579015, nil, nil, body_579016)

var doubleclicksearchReportsRequest* = Call_DoubleclicksearchReportsRequest_579002(
    name: "doubleclicksearchReportsRequest", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_DoubleclicksearchReportsRequest_579003,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsRequest_579004,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGenerate_579017 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchReportsGenerate_579019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsGenerate_579018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates and returns a report immediately.
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
  var valid_579026 = query.getOrDefault("fields")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fields", valid_579026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reportRequest: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579028: Call_DoubleclicksearchReportsGenerate_579017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates and returns a report immediately.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_DoubleclicksearchReportsGenerate_579017;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          reportRequest: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclicksearchReportsGenerate
  ## Generates and returns a report immediately.
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
  ##   reportRequest: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579030 = newJObject()
  var body_579031 = newJObject()
  add(query_579030, "key", newJString(key))
  add(query_579030, "prettyPrint", newJBool(prettyPrint))
  add(query_579030, "oauth_token", newJString(oauthToken))
  add(query_579030, "alt", newJString(alt))
  add(query_579030, "userIp", newJString(userIp))
  add(query_579030, "quotaUser", newJString(quotaUser))
  if reportRequest != nil:
    body_579031 = reportRequest
  add(query_579030, "fields", newJString(fields))
  result = call_579029.call(nil, query_579030, nil, nil, body_579031)

var doubleclicksearchReportsGenerate* = Call_DoubleclicksearchReportsGenerate_579017(
    name: "doubleclicksearchReportsGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports/generate",
    validator: validate_DoubleclicksearchReportsGenerate_579018,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGenerate_579019,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGet_579032 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchReportsGet_579034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchReportsGet_579033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Polls for the status of a report request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportId: JString (required)
  ##           : ID of the report request being polled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reportId` field"
  var valid_579035 = path.getOrDefault("reportId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "reportId", valid_579035
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
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579043: Call_DoubleclicksearchReportsGet_579032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Polls for the status of a report request.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_DoubleclicksearchReportsGet_579032; reportId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## doubleclicksearchReportsGet
  ## Polls for the status of a report request.
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
  ##   reportId: string (required)
  ##           : ID of the report request being polled.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "userIp", newJString(userIp))
  add(query_579046, "quotaUser", newJString(quotaUser))
  add(path_579045, "reportId", newJString(reportId))
  add(query_579046, "fields", newJString(fields))
  result = call_579044.call(path_579045, query_579046, nil, nil, nil)

var doubleclicksearchReportsGet* = Call_DoubleclicksearchReportsGet_579032(
    name: "doubleclicksearchReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{reportId}",
    validator: validate_DoubleclicksearchReportsGet_579033,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGet_579034,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGetFile_579047 = ref object of OpenApiRestCall_578355
proc url_DoubleclicksearchReportsGetFile_579049(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportId" in path, "`reportId` is a required path parameter"
  assert "reportFragment" in path, "`reportFragment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "reportFragment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchReportsGetFile_579048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a report file encoded in UTF-8.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportFragment: JInt (required)
  ##                 : The index of the report fragment to download.
  ##   reportId: JString (required)
  ##           : ID of the report.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportFragment` field"
  var valid_579050 = path.getOrDefault("reportFragment")
  valid_579050 = validateParameter(valid_579050, JInt, required = true, default = nil)
  if valid_579050 != nil:
    section.add "reportFragment", valid_579050
  var valid_579051 = path.getOrDefault("reportId")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "reportId", valid_579051
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
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("alt")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("json"))
  if valid_579055 != nil:
    section.add "alt", valid_579055
  var valid_579056 = query.getOrDefault("userIp")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "userIp", valid_579056
  var valid_579057 = query.getOrDefault("quotaUser")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "quotaUser", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579059: Call_DoubleclicksearchReportsGetFile_579047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Downloads a report file encoded in UTF-8.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_DoubleclicksearchReportsGetFile_579047;
          reportFragment: int; reportId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## doubleclicksearchReportsGetFile
  ## Downloads a report file encoded in UTF-8.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   reportFragment: int (required)
  ##                 : The index of the report fragment to download.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   reportId: string (required)
  ##           : ID of the report.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579061 = newJObject()
  var query_579062 = newJObject()
  add(query_579062, "key", newJString(key))
  add(query_579062, "prettyPrint", newJBool(prettyPrint))
  add(query_579062, "oauth_token", newJString(oauthToken))
  add(path_579061, "reportFragment", newJInt(reportFragment))
  add(query_579062, "alt", newJString(alt))
  add(query_579062, "userIp", newJString(userIp))
  add(query_579062, "quotaUser", newJString(quotaUser))
  add(path_579061, "reportId", newJString(reportId))
  add(query_579062, "fields", newJString(fields))
  result = call_579060.call(path_579061, query_579062, nil, nil, nil)

var doubleclicksearchReportsGetFile* = Call_DoubleclicksearchReportsGetFile_579047(
    name: "doubleclicksearchReportsGetFile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/reports/{reportId}/files/{reportFragment}",
    validator: validate_DoubleclicksearchReportsGetFile_579048,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGetFile_579049,
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
